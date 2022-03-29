Admin.create!(
  email: ENV['ADMIN_EMAIL'],
  password: ENV['ADMIN_PASSWORD']
  )

end_users = EndUser.create!(
  [
    {email: "hanako@test.com", name: "hanako", password: "password", introduction: "Hello!"},
    {email: "tarou@test.com", name: "tarou", password: "password", introduction: "おすすめを紹介します！"},
    {email: "momo@test.com", name: "momo", password: "password", introduction: "お気に入りを共有しましょう！"}
  ]
)

tags = Tag.create!(
  [
    {name: "#カフェ"},
    {name: "#KAU-KAU"},
    {name: "#ドゥリムトン村"},
    {name: "#観光地"},
    {name: "#駐車場あり"},
    {name: "#ほんたき寺巣"},
    {name: "#絶景"},
    {name: "#薬膳カレー"},
    {name: "#大鳳餃子"},
    {name: "#餃子"},
    {name: "#Miisuk"},
    {name: "#タイ料理"},
  ]
)


 
 spot = Spot.create(address: "兵庫県西宮市上甲東園3-9-8",
                    latitude: "34.7686",
                    longitude: "135.35",
                    introduction: "[絶品]牛たたきパスタすごくお勧めです！",
                    end_user_id: 1)
                    
spot.spot_images.attach(io: File.open(Rails.root.join('app/assets/images/sample-post1.jpg')),
                  filename: 'sample-post1.jpg')
  
# spot = Spot.create!(
#   [
#     {
#       address: "兵庫県西宮市上甲東園3-9-8",
#       latitude: "34.7686",
#       longitude: "135.35",
#       introduction: "[絶品]牛たたきパスタすごくお勧めです！",
#       # spot_images: File.open("#{Rails.root}/db/fixtures/sample-post1.jpg"),
#       spot_images: (io: File.open(Rails.root.join('app/assets/images/cat.jpg'))
#                   filename: 'cat.jpg'),
#       end_user_id: end_users[0].id,
#       # tag_id: [tags[0].id, tags[1].id]
#     },
    
#     {
#       address: "京都府亀岡市西別院町柚原水汲12",
#       latitude: "34.9606",
#       longitude: "135.51",
#       introduction: "イギリスの田舎町を再現した「ドゥリムトン村」",
#       # spot_images: File.open("#{Rails.root}/db/fixtures/sample-post2-2.jpg"),
#       end_user_id: end_users[1].id,
#     #   tag_id: [tags[2].id, tags[3].id, tags[4].id]
#     },
#     {
#       address: "大阪府豊能郡能勢町野間中718",
#       latitude: "34.9354",
#       longitude: "135.468",
#       introduction: "【絶景カフェ】薬膳カレーとふわふわなロールケーキとても美味しかったです！",
#       # spot_images: File.open("#{Rails.root}/db/fixtures/sample-post3-2.jpg"),
#       end_user_id: end_users[0].id,
#       # tag_id: [tags[0].id, tags[4].id, tags[5].id, tags[6].id, tags[7].id]
#     },
#     {
#       address: "京都府京都市中京区寺町押小路西入る亀屋町405",
#       latitude: "35.0121",
#       longitude: "135.767",
#       introduction: "タイ料理が好きになったきっかけのお店!\r\nタイ料理が好きな方にも苦手な方にもおすすめです！",
#       # spot_images: File.open("#{Rails.root}/db/fixtures/sample-post4.jpg"),
#       end_user_id: end_users[2].id,
#       # tag_id: [tags[10].id, tags[11].id, tags[0].id]
#     },
#     {
#       address: "兵庫県神戸市東灘区深江北町1丁目13-3",
#       latitude: "34.7264",
#       longitude: "135.297",
#       introduction: "見た目も可愛くて、色んな味を楽しめるマカロン餃子！\r\nお店の方もとても温かく、また行きたいお気に入りのお店です！",
#       # spot_images: File.open("#{Rails.root}/db/fixtures/sample-post5.jpg"),
#       end_user_id: end_users[2].id,
#       # tag_id: [tags[8].id, tags[9].id]
#     }
#   ]
# )
