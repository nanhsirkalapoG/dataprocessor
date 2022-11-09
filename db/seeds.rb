# frozen_string_literal: true

User.create!(
  [{
    first_name: 'Magnus',
    last_name: 'Carlsen',
    email: 'magnus.c@testchess.com',
    password: 'password'
  },
   {
     first_name: 'Anand',
     last_name: 'Viswanathan',
     email: 'vishy.a@testchess.com',
     password: 'password'
   }]
)

Product.create!(
  [{
    title: 'Mangetic Chess Board',
    description: 'Chess Board',
    price: 10.45,
    external_id: 'chess_board_1',
    user_id: User.first.id
  },
   {
     title: 'Small Chess Board',
     description: 'Chess Board',
     price: 4.45,
     external_id: 'chess_board_2',
     user_id: User.last.id
   }]
)
