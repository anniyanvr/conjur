Feature: Certificates issued by the login method.

  Scenario: The subject name is the dot-separated, with hard-coded apps prefix, Conjur host ID when the "Common-Name-Type" header isn't present.
    When I can login to pod matching "app=inventory-pod" to authn-k8s as "*/*"
    Then the certificate subject name is "/CN=host.conjur.authn-k8s.minikube.apps.@namespace@.*.*"

  Scenario: The subject name is the dot-separated given Conjur host ID in apps when the "Common-Name-Type" header is present
    When I can login to pod matching "app=inventory-pod" to authn-k8s as full host-id "host/conjur/authn-k8s/minikube/apps/@namespace@/*/*"
    Then the certificate subject name is "/CN=host.conjur.authn-k8s.minikube.apps.@namespace@.*.*"

  Scenario: The subject name is the dot-separated given Conjur host ID outside of apps when the "Common-Name-Type" header is present
    When I can login to pod matching "app=inventory-pod" to authn-k8s as full host-id "host/some-policy/@namespace@/*/*"
    Then the certificate subject name is "/CN=host.some-policy.@namespace@.*.*"

  Scenario: The TTL of the certificate is 3 days.
    When I can login to pod matching "app=inventory-pod" to authn-k8s as "*/*"
    Then the certificate is valid for 3 days
