resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.name}"
  retention_in_days = var.log_retention_days
}

# 5xx returned by the ALB itself (no healthy targets) plus 5xx returned by the app
resource "aws_cloudwatch_metric_alarm" "http_5xx" {
  alarm_name          = "${var.name}-http-5xx"
  alarm_description   = "Too many 5xx responses on ${var.name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  threshold           = var.alarm_5xx_threshold
  treat_missing_data  = "notBreaching"

  metric_query {
    id          = "total"
    expression  = "FILL(elb, 0) + FILL(target, 0)"
    label       = "5xx count"
    return_data = true
  }

  metric_query {
    id = "elb"

    metric {
      namespace   = "AWS/ApplicationELB"
      metric_name = "HTTPCode_ELB_5XX_Count"
      period      = 60
      stat        = "Sum"
      dimensions = {
        LoadBalancer = aws_lb.this.arn_suffix
      }
    }
  }

  metric_query {
    id = "target"

    metric {
      namespace   = "AWS/ApplicationELB"
      metric_name = "HTTPCode_Target_5XX_Count"
      period      = 60
      stat        = "Sum"
      dimensions = {
        LoadBalancer = aws_lb.this.arn_suffix
      }
    }
  }
}
