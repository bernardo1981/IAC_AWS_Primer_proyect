# main.tf

# Configurar el proveedor de AWS
provider "aws" {
  region = "us-east-1" # Cambia a tu región preferida
}

# Crear una clave SSH para acceder a la instancia
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer_key" {
  key_name   = "deployer-key"
  public_key = tls_private_key.example.public_key_openssh
}

# Crear una instancia de EC2
resource "aws_instance" "my_vm" {
  ami           = "ami-0c55b159cbfafe1f0" # Cambia esto por la AMI que prefieras
  instance_type = "t2.micro"

  key_name = aws_key_pair.deployer_key.key_name

  tags = {
    Name = "TerraformExampleVM"
  }
}

# Output para la dirección IP pública de la instancia
output "instance_ip_addr" {
  value = aws_instance.my_vm.public_ip
}
