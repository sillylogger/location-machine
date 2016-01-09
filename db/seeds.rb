# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.create email: 'chrstnatalia@gmail.com', password: 'password',
            name: 'Lia', avatar_url: 'http://k3.okccdn.com/php/load_okc_image.php/images/0x0/0x0/2/9603652731835019710.webp'

User.create email: 'tommy.b.sullivan@gmail.com', password: 'password',
            name: 'Tommy', avatar_url: 'http://k1.okccdn.com/php/load_okc_image.php/images/150x150/558x800/410x349/878x817/0/13406059829553961563.webp'


