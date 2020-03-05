# Ansible playbook to migrate VMs from a IaaS to another

This playbook is intended to help migrate VMs from a Cloudstack instance to another.
It should also be possible to migrate from a zone to another in the same Cloudstack instance.

# Prerequisite

* python >= 2.6
* ansible >= 2.8
* cs >= 0.6.10

# How to use?

### Configure your deployment

Copy inventory file and group_vars from the `example` directory.

Edit the `inventory` file:
* setup your host groups
* setup options (see the "Options" session below)
* add VMs you want to migrate into host groups

Edit the group_vars files to configure source and destination.

Run the playbook!

Example run:

~~~
ansible-playbook -i inventory site.yml -v
~~~

### Rollback

If a problem appears during migration, use the rollback playbook which allows you to return to the initial state.

Just run:

~~~
ansible-playbook -i inventory rollback.yml -v
~~~

# Options

## Playbook

### affinity_policy

* auto (default): Affinity groups are retrieved from the source IaaS. If they don't exist, the host groups will be used as a base.
* groups: An affinity group will be created for each host group.
* no: No affinity group.

Affinity groups should not be ignored because they ensure a better distribution of your virtual machines across different hosts.
If the number of your VM is too important, you may consider splitting them into several host groups.

#### force_yes

By default, you will be asked to confirm before migrating each virtual machine. This gives you the opportunity to do any manual operations before starting the migration.
If true, do not ask for confirmation before stopping source VMs.

## HVM migration

#### hvm_migration

Either or not migrate from PV to PVHVM (Xen VMs only).

The PVHVM mode is more efficient and more secure. It is highly recommended to do the migration.

If true, grub2 will be configured and the VM template will be registered as a HVM template.

#### hvm_destination_os

Required when migrating to HVM. The OS of destination template.

The OS of destination template.

Defaulted to `Ubuntu 16.04 (64-bit)`.

Consider changing the version only if you want to migrate VMs that have an older OS.

## Networking

#### vrouter_reserved_ip

The IP address that will be given to the vrouter on the default network (choose one that is not already assigned).

# Customization

You can add tasks in 'before_migration.yml' and 'after_migration.yml' that will be run before and after the migration of each VM to adapt the playbook to your needs.

#### before_migration

Tasks that will be run just before stopping the source VM.

For example, you can remove the VM from the loadbalancer or stop some applications properly before shutting down the VM.

#### after_scripts

Tasks that will be run after starting the destination VM.

If you want to re-enable the VM in the loadbalancer, consider playing it after the VM restart task.
