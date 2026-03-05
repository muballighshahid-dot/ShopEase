# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  def product_created
    NotificationMailer.product_created(Product.first)
  end

  def product_updated
    NotificationMailer.product_updated(Product.first)
  end

  def order_status_changed
    NotificationMailer.order_status_changed(Order.first)
  end

  def important_alert
    NotificationMailer.important_alert(User.first, important: true)
  end

  def invoice_email
    NotificationMailer.invoice_email(Order.first)
  end

  def login_alert
    NotificationMailer.login_alert(User.first)
  end
end
