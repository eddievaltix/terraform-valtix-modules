#############################################
# Create S3 bucket / IAM Roles / IAM Policies
#############################################

# create the S3 bucket for tech supports and PCAPs
resource "aws_s3_bucket" "techsupport" {
  bucket = format("valtix-%s-techsupport", replace(var.prefix, "_", "-"))
  acl    = "private"
  tags = {
    Name   = "valtix-${var.prefix}-techsupport"
    prefix = var.prefix
  }
}

# create a role that will be used by valtix firewall with permissions to
# write techsupport/pcap files to s3 buckets

resource "aws_iam_role" "valtix_fw_role" {
  name = "valtix-firewall-role"
  tags = {
    Name   = "valtix-firewall-role"
    prefix = var.prefix
  }

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "valtix_fw_policy" {
  name = "valtix_fw_policy"
  role = aws_iam_role.valtix_fw_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource":"${aws_s3_bucket.techsupport.arn}/*"
    },
    {
      "Action": [
        "kms:Decrypt"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "secretsmanager:GetSecretValue"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# for instances to use the role, an instance profile must be created and
# instance profile name used on the instance's iam role
# however on the firewall iam role text box you can provide the role
# name or the arn of either the role or the instance profile
resource "aws_iam_instance_profile" "valtix_fw_role" {
  name = "valtix-firewall-role"
  role = aws_iam_role.valtix_fw_role.name
}

# create a role that will be used by valtix controller with permissions
resource "aws_iam_role" "valtix_controller_role" {
  name = "valtix-controller-role"

  tags = {
    Name   = "valtix-controller-role"
    prefix = var.prefix
  }

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${var.controller_aws_account_number}:root"
        ]
      },
      "Effect": "Allow",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "valtix"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "valtix_controller_policy" {
  name = "valtix_controller_policy"
  role = aws_iam_role.valtix_controller_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Action": [
          "route53:ListHostedZones",
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets",
          "route53:ListHostedZonesByName",
          "ec2:*",
          "elasticloadbalancing:*",
          "apigateway:GET"
        ],
        "Effect": "Allow",
        "Resource": "*"
    },
    {
      "Action": [
        "iam:GetRole",
        "iam:ListRolePolicies",
        "iam:GetRolePolicy"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::${var.controller_aws_account_number}:role/valtix-controller-role"
      ]
    },
    {
      "Action": "servicequotas:GetServiceQuota",
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "iam:GetRole",
        "iam:ListRolePolicies",
        "iam:GetRolePolicy",
        "iam:PassRole"
      ],
      "Effect": "Allow",
      "Resource": "${aws_iam_role.valtix_fw_role.arn}"
    },
    {
      "Action": "iam:CreateServiceLinkedRole",
      "Effect": "Allow",
      "Resource": "arn:aws:iam::*:role/aws-service-role/*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "valtix_cloudwatch_event_role" {
  name = "valtix-inventory-role"
  tags = {
    Name   = "valtix-inventory-role"
    prefix = var.prefix
  }

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "valtix_cloudwatch_event_policy" {
  name = "valtix_cloudwatch_event_policy"
  role = aws_iam_role.valtix_cloudwatch_event_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "events:PutEvents",
      "Effect": "Allow",
      "Resource": [
        "arn:aws:events:*:${var.controller_aws_account_number}:event-bus/default"
      ]
    }
  ]
}
EOF
}
