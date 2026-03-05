class NotificationMailer < ApplicationMailer
  default from: "no-reply@myapp.com"
  layout "mailer"

  def product_created(product)
    @product = product
    mail(to: product.user.email, subject: "Product Created Successfully")
  end

  def product_updated(product)
    @product = product
    mail(to: product.user.email, subject: "Product Updated")
  end

  def order_status_changed(order)
    @order = order
    subject_line = case order.status
                   when "confirmed" then "Your Order is Confirmed"
                   when "shipped"   then "Your Order Has Been Shipped"
                   when "cancelled" then "Your Order Was Cancelled"
                   else "Order Update"
                   end

    mail(to: order.user.email, subject: subject_line)
  end

  def important_alert(user, important: false)
    return if user.notification_preference_important_only? && !important

    @user = user
    mail(to: user.email, subject: "Important Alert")
  end

  def invoice_email(order)
    @order = order

    if order.invoice_pdf.attached?
      attachments[order.invoice_pdf.filename.to_s] = order.invoice_pdf.download
    else
      attachments["invoice_#{order.id}.txt"] = "Invoice for Order ##{order.id}"
    end

    mail(to: order.user.email, subject: "Your Invoice")
  end

  def login_alert(user)
    @user = user
    @login_time = Time.current
    mail(to: user.email, subject: "New Login Alert")
  end
end
