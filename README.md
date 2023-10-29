# jtviegas.com website
- https://jtviegas.com
- https://dev.jtviegas.com

## development

### getting started
- run `./helper.sh prereqs` to find out what you need in your development environment

- we obviously assume you have git installed :-)

- configure aws cli with the main user account: `aws configure` or set the desired profile (`export AWS_PROFILE=USER`)
- add `solution` name in `basic/main.tfvars`
- [register your domain on aws route53](https://us-east-1.console.aws.amazon.com/route53/v2/home#Dashboard)
  - add the domain name and define the remaining variables, accordingly, in `resources/main.tfvars` 
  - also accordingly, edit `MAIN_WEBSITE_BUCKET` and `DEV_WEBSITE_BUCKET` variables in `.variables`
- run : `./helper.sh infra-basic-on` to setup an automated aws user and the terraform state bucket
- run : `./helper.sh infra-resources-on` to link domain, certificate, the s3 website and its distribution