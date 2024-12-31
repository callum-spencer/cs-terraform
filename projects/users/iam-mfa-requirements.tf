resource "aws_iam_group_membership" "iam_mfa_requirements" {
  name = "iam-mfa-requirements"

  users = [
    aws_iam_user.example-user.name,
  ]

  group = aws_iam_group.iam_mfa_requirements.name
}

resource "aws_iam_group" "iam_mfa_requirements" {
  name = "iam-mfa-requirements"
  path = "/"
}

resource "aws_iam_policy" "iam_mfa_requirements" {
  name        = "iam-mfa-requirements"
  description = "A policy to enforce restrictions on MFA tokens and allow specific actions on the Users account by users."
  policy      = file("./mfa_policy.json")
}

resource "aws_iam_group_policy_attachment" "iam_mfa_requirements" {
  group      = aws_iam_group.iam_mfa_requirements.name
  policy_arn = aws_iam_policy.iam_mfa_requirements.arn
}
