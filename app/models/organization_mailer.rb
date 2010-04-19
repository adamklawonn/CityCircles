class OrganizationMailer < ActionMailer::Base
  
  def promo_approved( promo )
    recipients  promo.organization.organization_members.collect { | member | member.user.email }
    from  "members@citycircles.com"
    subject "Your promotion has been approved!"
    body  :promo => promo
  end

  def ad_approved( ad )
    recipients  ad.organization.organization_managers.collect { | member | member.user.email }
    from  "members@citycircles.com"
    subject "Your ad has been approved!"
    body  :ad => ad
  end

end
