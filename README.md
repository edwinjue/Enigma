# Enigma
<br>
From the terminal clone the respoitory, change to Enigma directory and execute pry:<br>
>   git clone https://github.com/edwinjue/Enigma.git<br>
>   cd Enigma<br>
>   pry<br>
  <br>
Run the following in `pry`:<br>
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
> e.crack(output, Date.today)<br>
=> "this is so secret ..end.."<br>
> e.crack(output) # Date is optional, use today's date<br>
=> "this is so secret ..end.."<br>
