Rails.application.routes.draw do
  scope path: 'en' do
    mount BookingsyncPortal::Engine => '/'
  end
end
