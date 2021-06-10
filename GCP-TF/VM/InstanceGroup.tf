resource "google_compute_instance_template" "petshop_template" {
  name_prefix  = "tf-custom-petshop"
  machine_type = "e2-medium"
  can_ip_forward       = true
  region       = "us-central1"
  project      =  "wise-sphere-316206"

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  
    
  disk {
    source_image = "projects/wise-sphere-316206/global/images/petshop"
    auto_delete       = true
    boot              = true
     
  }

  network_interface {
    subnetwork_project = "wise-sphere-316206"  
    subnetwork = "public-subnet-01"
    access_config {
      // Ephemeral IP
    }
      
  }

  
}


resource "google_compute_region_instance_group_manager" "appserver" {
  name = "petshop-igm"

  base_instance_name         = "petshop-img-instance"
  region                     = "us-central1"
  distribution_policy_zones  = ["us-central1-b", "us-central1-c"]
  project                    = "wise-sphere-316206"

  version {
    instance_template = google_compute_instance_template.petshop_template.id
  }

  target_size  = 2

  
 
}