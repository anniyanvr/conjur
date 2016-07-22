Feature: Users and groups can be added to groups

  Scenario: Create a group of groups
  
    In this example we are giving the `group:employees` role to groups `developers` and `operations`. 
    This effectively adds groups `developers` and `operations` to the `employees` group. They are 
    granted all privileges of the `employees` group.
  
    Note the replace: true option. This means that if a group named `employees` already exists, 
    remove all members and replace with the roles in the members list. Replacing members gives you a 
    more authoritive answer to the question "who is in this group?", but may not work if you are 
    referencing global roles in your policy.
    
    Given a policy:
    """
    # First create the groups
    - !group employees
    - !group developers
    - !group operations
    
    # Now grant group employees to groups developers and developers
    - !grant
      replace: true
      role: !group employees
      members:
      - !group developers
      - !group operations
    """
    When I show the group "employees"
    Then group "developers" is a role member
    And group "operations" is a role member

  Scenario: Add an administrator to a group
    In this example, a group `ci-admin` gets an admin grant on the group `ci`. This means that 
    members of the group `ci-admin` can add and remove members from the group `ci`. In real-world 
    terms, everyone who uses your Jenkins system may be in the `ci` group. A smaller group of 
    Jenkins admins are in the `ci-admin` group, and can manage who is in the `ci` group.

    Note how group `ci-admin` is aliased with the name "admin" in the policy. This is effectively 
    creating a reference to that group we can use later in the policy. Aliasing policy records makes 
    policies DRYer and easier to maintain. By using a reference, `!group ci-admin` is defined once in the policy
    and then later used by reference. Create an alias by declaring a 
    name prepended with `&`. Dereference that record later on in your policy by using the same name prepended 
    with a `*`. Aliasing also allows you to group records together under a single symbolic name.
    
    Given a policy:
    """
    - !group ci
    
    - !group &admin ci-admin
    
    - !grant
      role: !group ci
      member: !member 
        role: *admin
        admin: true
    """
    When I show the group "ci"
    Then group "ci-admin" is a role member with admin option
