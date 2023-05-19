from azure.identity import InteractiveBrowserCredential
from azure.mgmt.compute import ComputeManagementClient
from azure.mgmt.network import NetworkManagementClient


tenant_id = '<tenant ID>'
subscription_id = '<subscription ID>'
credential = InteractiveBrowserCredential(tenant_id=tenant_id, subscription_id=subscription_id)

# Create the Compute Management and Network Management clients
compute_client = ComputeManagementClient(credential, subscription_id)
network_client = NetworkManagementClient(credential, subscription_id)

ip_address = '<IP Addres you want to search>'

# Search for the IP address in Virtual Machines
vm_list = compute_client.virtual_machines.list_all()
for vm in vm_list:
    if hasattr(vm, 'network_profile') and hasattr(vm.network_profile, 'network_interfaces'):
        for interface_ref in vm.network_profile.network_interfaces:
            interface_id = interface_ref.id
            interface_name = interface_id.split('/')[-1]
            resource_group_name = interface_id.split('/')[4].lower()
            interface = network_client.network_interfaces.get(resource_group_name, interface_name)
            if hasattr(interface, 'ip_configurations'):
                for config in interface.ip_configurations:
                    if hasattr(config, 'private_ip_address') and config.private_ip_address == ip_address:
                        print("Virtual Machine ID:", vm.id)
                        print("Virtual Machine Name:", vm.name)
                        print("Interface ID:", interface.id)
                        print("Interface Name:", interface.name)
                        print("---------------------------------")

# Search for the IP address in Network Interfaces
interface_list = network_client.network_interfaces.list_all()
for interface in interface_list:
    if hasattr(interface, 'ip_configurations'):
        for config in interface.ip_configurations:
            if hasattr(config, 'private_ip_address') and config.private_ip_address == ip_address:
                print("Interface ID:", interface.id)
                print("Interface Name:", interface.name)
                print("---------------------------------")