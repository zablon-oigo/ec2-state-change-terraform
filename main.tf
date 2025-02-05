provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_security_group" "web-server" {
  name        = "web-server"
  description = "Allow incoming HTTP Connections"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "test_key" {
  key_name   = "test"
  public_key = tls_private_key.example.public_key_openssh
}

resource "aws_instance" "web-server" {
  ami             = var.ami
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.test_key.key_name
  security_groups = ["${aws_security_group.web-server.name}"]
  tags = {
    Name = "WebServer"
  }
}

resource "aws_sns_topic" "topic" {
  name = "MyServerMonitor"
}

resource "aws_sns_topic_subscription" "topic-subscription" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "email"
  endpoint  = var.endpoint
}

resource "aws_cloudwatch_event_rule" "event" {
  name          = "MyEC2StateChangeEvent"
  description   = "MyEC2StateChangeEvent"
  event_pattern = <<EOF
{
  "source": [
    "aws.ec2"
  ],
  "detail-type": [
    "EC2 Instance State-change Notification"
  ]
}
EOF
}
resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.event.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.topic.arn
}
resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.topic.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}
data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    resources = [aws_sns_topic.topic.arn]
  }
}
