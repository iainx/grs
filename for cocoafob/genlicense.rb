#!/usr/bin/env ruby
#
# Modify this file and put in your own license key generator
#

require "openssl"
require "rubygems"
require "base32"
require "base64"

def make_license_source(product_code, name)
  product_code + "," + name
end

def make_license(product_code, name)
  sign_dss1 = OpenSSL::Digest::DSS1.new
  priv = OpenSSL::PKey::DSA.new(File.read("privkey.pem"))
  b32 = Base32.encode(priv.sign(sign_dss1, make_license_source(product_code, name)))
  # Replace Os with 8s and Is with 9s
  # See http://members.shaw.ca/akochoi-old/blog/2004/11-07/index.html
  b32.gsub!(/O/, '8')
  b32.gsub!(/I/, '9')
  # chop off trailing padding
  b32.delete("=").scan(/.{1,5}/).join("-")
end

def license_url(name, lickey)
  licensee_name_b64 = Base64.encode64(name)
  return "appgrid://#{licensee_name_b64}/#{lickey}"
end

if __FILE__ == $0
  name = ARGV.join ' '
  lic = make_license('AppGrid', name)
  puts 'License Name: ' + name
  puts 'License Code: ' + lic
  puts 'Auto-register URL: ' + license_url(name, lic)
end
