# Enigma

`pry`<br>
> require './enigma'<br>
> e = Enigma.new<br>
> my_message = "this is so secret ..end.."<br>
> output = e.encrypt(my_message)<br>
=> # encrypted message here<br>
> output = e.encrypt(my_message, 12345, Date.today) #key and date are optional (gen random key and use today's date)<br>
=> # encrypted message here<br>
> e.decrypt(output, 12345, Date.today)<br>
=> "this is so secret ..end.."<br>
> e.decrypt(output, 12345) # Date is optional (use today's date)<br>
=> "this is so secret ..end.."<br>
<br>
#crack functionality not working yet<br>
> e.crack(output, Date.today)<br>
=> "this is so secret ..end.."<br>
> e.crack(output) # Date is optional, use today's date<br>
=> "this is so secret ..end.."<br>
