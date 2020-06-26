# mcs-haneyland-deploy

ansible playbooks to push this neato minecraft server container to a host of your choice.

## usage

1. Create your inventory file:

```
echo "my.full.host.name" > inventory
# or perhaps even
echo "my_wonderful_host_alias ansible_host=1.2.3.4" > inventory
```

1. Manage SSH credentials

You can use `copyid.yml` to push whatever `ansible_user` and `ansible_ssh_private_key_file` to all hosts as you wish.

```
# throw an ssh password at bash
ansible-playbook -i inventory copyid.yml -k
# throw your password into a vault even
ansible-playbook -i inventory copyid.yml --vault-id whatever@prompt
```

## TODO

* Move common roles to their own repos
