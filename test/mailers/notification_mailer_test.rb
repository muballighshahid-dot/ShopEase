require "test_helper"

class NotificationMailerTest < ActionMailer::TestCase
  fixtures :users, :categories, :products, :orders

  test "product_created email" do
    product = products(:one)
    mail = NotificationMailer.product_created(product)

    assert_equal ["no-reply@myapp.com"], mail.from
    assert_equal [product.user.email], mail.to
    assert_equal "Product Created Successfully", mail.subject
    assert_match product.name, mail.body.encoded
  end

  test "product_updated email" do
    product = products(:one)
    mail = NotificationMailer.product_updated(product)

    assert_equal ["no-reply@myapp.com"], mail.from
    assert_equal [product.user.email], mail.to
    assert_equal "Product Updated", mail.subject
    assert_match product.name, mail.body.encoded
  end

  test "order_status_changed email" do
    order = orders(:one)
    order.status = :shipped
    mail = NotificationMailer.order_status_changed(order)

    assert_equal ["no-reply@myapp.com"], mail.from
    assert_equal [order.user.email], mail.to
    assert_equal "Your Order Has Been Shipped", mail.subject
    assert_match order.order_number, mail.body.encoded
  end

  test "important_alert respects important_only preference" do
    user = users(:one)
    user.update_column(:notification_preference, User.notification_preferences[:important_only])
    delivery = NotificationMailer.important_alert(user)

    assert_instance_of ActionMailer::Base::NullMail, delivery.message
  end

  test "important_alert sends for important updates" do
    user = users(:one)
    user.update_column(:notification_preference, User.notification_preferences[:important_only])
    mail = NotificationMailer.important_alert(user, important: true)

    assert_equal ["no-reply@myapp.com"], mail.from
    assert_equal [user.email], mail.to
    assert_equal "Important Alert", mail.subject
  end

  test "invoice_email attaches fallback text file when no pdf exists" do
    order = orders(:one)
    mail = NotificationMailer.invoice_email(order)

    assert_equal ["no-reply@myapp.com"], mail.from
    assert_equal [order.user.email], mail.to
    assert_equal "Your Invoice", mail.subject
    assert_equal 1, mail.attachments.count
    assert_equal "invoice_#{order.id}.txt", mail.attachments.first.filename
  end

  test "invoice_email attaches uploaded pdf when available" do
    order = orders(:one)
    order.invoice_pdf.attach(
      io: StringIO.new("fake-pdf-data"),
      filename: "invoice.pdf",
      content_type: "application/pdf"
    )

    mail = NotificationMailer.invoice_email(order)

    assert_equal 1, mail.attachments.count
    assert_equal "invoice.pdf", mail.attachments.first.filename
  end

  test "login_alert email" do
    user = users(:one)
    mail = NotificationMailer.login_alert(user)

    assert_equal ["no-reply@myapp.com"], mail.from
    assert_equal [user.email], mail.to
    assert_equal "New Login Alert", mail.subject
    assert_match "signed in", mail.body.encoded
  end
end
