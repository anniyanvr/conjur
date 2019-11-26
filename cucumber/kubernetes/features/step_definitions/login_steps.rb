def login username, request_ip, authn_k8s_host, pkey, headers = {}
  csr = gen_csr(username, pkey, [
    "URI:spiffe://cluster.local/namespace/#{@pod.metadata.namespace}/pod/#{@pod.metadata.name}"
  ])

  headers[:content_type] = 'text/plain'

  response =
    RestClient::Resource.new(
      authn_k8s_host,
      ssl_ca_file: './nginx.crt',
      headers: headers
    )["inject_client_cert?request_ip=#{request_ip}"].post(csr.to_pem)

  @cert = pod_certificate

  if @cert.to_s.empty?
    warn "WARN: Certificate is empty!"
  end

  response
end

def login_with_relative_id request_ip, id, success
  username = [ namespace, id ].join('/')
  login_with_username(request_ip, username, success)
end

def login_with_full_id request_ip, id, success
  headers = { 'Common-Name-Type' => 'full' }
  username = substitute(id)

  login_with_username(request_ip, username, success, headers)
end

def login_with_username request_ip, username, success, headers = {}
  begin
    @pkey = OpenSSL::PKey::RSA.new 1048
    login(username, request_ip, authn_k8s_host, @pkey, headers)
  rescue
    raise if success
    @error = $!
  end

  expect(@cert).to include("BEGIN CERTIFICATE") unless @cert.to_s.empty?
end

Then(/^I( can)? login to pod matching "([^"]*)" to authn-k8s as( full host-id)? "([^"]*)"$/) do |success, objectid, is_full_host_id, host_id|
  @request_ip ||= find_matching_pod(objectid)

  if is_full_host_id
    login_with_full_id(@request_ip, host_id, success)
  else
    login_with_relative_id(@request_ip, host_id, success)
  end
end

Then(/^I( can)? login to authn-k8s as( full host-id)? "([^"]*)"$/) do |success, is_full_host_id, objectid|
  if is_full_host_id
    # we take only the object type and id
    objectid_suffix = objectid.split('/').last(2).join('/')
    @request_ip ||= detect_request_ip(objectid_suffix)
    login_with_full_id(@request_ip, objectid, success)
  else
    @request_ip ||= detect_request_ip(objectid)
    login_with_relative_id(@request_ip, objectid, success)
  end
end

When(/^I launch many concurrent login requests$/) do
  objectid = "pod/inventory-pod"
  request_ip ||= detect_request_ip(objectid)
  @errors = errors = []

  username = [ namespace, "*", "*" ].join('/')

  @request_threads = (0...50).map do |i|
    sleep 0.05
    Thread.new do
      begin
        login(username, request_ip, authn_k8s_host, OpenSSL::PKey::RSA.new(1048))
      rescue
        errors << $!
      end
    end
  end
end

Then(/^at least one response status is (\d+)$/) do |arg1|
  @request_threads.map(&:join)

  expect(@errors.map{ |e| e.respond_to?(:http_code) && e.http_code }).to include(503)
end

When(/^the certificate subject name is "([^"]*)"$/) do |subject_name|
  certificate = OpenSSL::X509::Certificate.new(@cert)
  expect(certificate.subject.to_s).to eq(substitute(subject_name))
end

When(/^the certificate is valid for 3 days$/) do ||
  certificate = OpenSSL::X509::Certificate.new(@cert)
  expect(certificate.not_after - certificate.not_before).to eq(3 * 24 * 60 * 60)
end
