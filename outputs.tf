output "alb_dns" {
  description = "DNS of the ALB"
  value       = "ALB Load Balencer ip: ${aws_lb.alb.dns_name}"
}
