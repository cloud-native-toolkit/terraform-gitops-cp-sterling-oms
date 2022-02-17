
resource null_resource write_outputs {
  provisioner "local-exec" {
    command = "echo \"$${OUTPUT}\" > gitops-output.json"

    environment = {
      OUTPUT = jsonencode({
        name        = module.oms.name
        branch      = module.oms.branch
        namespace   = module.oms.namespace
        server_name = module.oms.server_name
        layer       = module.oms.layer
        layer_dir   = module.oms.layer == "infrastructure" ? "1-infrastructure" : (module.oms.layer == "services" ? "2-services" : "3-applications")
        type        = module.oms.type
      })
    }
  }
}
