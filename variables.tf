variable "instance_type" {
  description = "The EC2 instance type to use. Try m7i-flex.large first. If it fails, use t3.small or t3.micro."
  # UNCOMMENT ONE OF THE LINES BELOW:
  
  default = "m7i-flex.large"   # Option 1: BEST (8GB RAM) - Fast & Smooth
  # default = "t3.small"       # Option 2: GOOD (2GB RAM) - Minimum recommended
  # default = "t3.micro"       # Option 3: SLOW (1GB RAM) - Only use if others fail
}