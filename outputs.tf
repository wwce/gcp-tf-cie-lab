output "ssh_branch1_vm1" {
  value       = "ssh ${var.vm_user}@${module.branch1_vmseries.public_ips[0]} -p 1001"
}

output "ssh_branch1_vm2" {
  value       = "ssh ${var.vm_user}@${module.branch1_vmseries.public_ips[0]} -p 1002"
}

output "ssh_branch1_vm3" {
  value       = "ssh ${var.vm_user}@${module.branch1_vmseries.public_ips[0]} -p 1003"
}

output "ssh_branch2_vm1" {
  value       = "ssh ${var.vm_user}@${module.branch2_vmseries.public_ips[0]} -p 2001"
}

output "ssh_branch2_vm2" {
  value       = "ssh ${var.vm_user}@${module.branch2_vmseries.public_ips[0]} -p 2002"
}


output "url_branch1_vmseries" {
  value       = "https://${module.branch1_vmseries.public_ips[1]}"
}

output "url_branch2_vmseries" {
  value       = "https://${module.branch2_vmseries.public_ips[1]}"
}
