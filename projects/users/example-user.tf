resource "aws_iam_user" "example_user" {
    name = "example-user"
    path = "/"
    tags = {
     CreatedBy        = "Devops"
    }
}

resource "aws_iam_user_login_profile" "example_user" {
  user    = aws_iam_user.example-user.name
  pgp_key = local.shared_pgp_key

  lifecycle {
    ignore_changes = [password_length, password_reset_required, pgp_key]
  }
}

output "example_userpassword" {
  value = aws_iam_user_login_profile.example-user.encrypted_password
}



# group

resource "aws_iam_group_membership" "example_user" {
  name = "example-user"

  users = [
    aws_iam_user.example-user.name
  ]

  group = aws_iam_group.example-user.name
}

resource "aws_iam_group" "example_user" {
  name = "example-user"
  path = "/"
}

resource "aws_iam_policy" "example_user" {
  name        = "example-user"
  description = "A policy to allow assumption of roles in the Development account."
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ProductionUK",
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "arn:aws:iam::6546849813:role/readonly"
    },
    {
      "Sid": "StagingUK",
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "arn:aws:iam::8676168187:role/poweruser"
    }
  ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "example_user" {
  group      = aws_iam_group.example-user.name
  policy_arn = aws_iam_policy.example-user.arn
}
