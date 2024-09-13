output "role_assignment_ids" {
  description = "The IDs for this Azure Role Assignment."
  value       = [for assignment in azurerm_role_assignment.this : assignment.id]
}
