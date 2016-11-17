function run(msg)
	help_sudo = "*Sudo Commands:*\n______________________________\n"
	.."     /req\n   ليست درخواستها\n\n"
	.."     /req>\n   کیبرد ليست درخواستها\n\n"
	.."     /sendtoall {text}\n   ارسال به همه\n\n"
	.."     /users\n   کاربران ربات\n\n"
	.."     /info {text}\n   توضيحات شما\n\n"
	.."     /avatar {reply photo}\n   آواتار شما\n\n"
	.."     /block {id},{in chat}\n   بلاک کردن\n\n"
	.."     /unblock {id}\n   آن بلاک\n\n"
	.."     /blocklist\n   ليست افراد بلاک\n\n"
	.."     /blocklist>\n   کیبرد افراد بلاک\n\n"
	.."     /promote {id}\n   اجازه ارسال پيامک\n\n"
	.."     /demote {id}\n   گرفتن دسترسي\n\n"
	.."     /friends\n   ليست دوستان\n\n"
	.."     /friends>\n   کیبرد لیست دوستان\n\n"
	.."     /del {id}\n   رد درخواست\n\n"
	.."     /chat {id}\n   شروع چت\n\n"
	.."     /end\n   اتمام چت\n\n"
	.."     /spam {id,num,text}\n   اسپم دادن\n\n"
	.."     /key\n   کيبرد ادمين\n\n"
	about_txt = "\n"
	start_txt = "`سلام به ربات پیامرسان اسپید خوش آمدید` \n---------------------------------------------\n`برای خرید ربات پیامرسان همین جا پیام دهید`\n` مجهز به سیستم ضد اسپمر`\n `پیام همگانی و آمار ربات`\n`بلاک و انبلاک`\n`و .... کلی قابلیت دیگه`\n`قیمت خرید 13 تومان`\n\n لطفا یک گزینه را انتخاب کنید"
	start_key = {{{text="کانال ما",url="https://telegram.me/news_speed"}}}
	keyboard = {{"📋بیوگرافی من📋"},{{text="💠ارسال شماره شما💠",request_contact=true},{text="🏡ارسال لوکیشن شما🏡",request_location=true}},{"📞شماره سازنده📞"},{"🎙شروع چت🎙"}}
	------------------------------------------------------------------------------------
	blocks = load_data("blocks.json")
	chats = load_data("chats.json")
	requests = load_data("requests.json")
	contact = load_data("contact.json")
	location = load_data("location.json")
	users = load_data("users.json")
	admins = load_data("admins.json")
	setting = load_data("setting.json")
	userid = tostring(msg.from.id)
	msg.text = msg.text:gsub("@"..bot.username,"")
	
	if msg.chat.id == admingp then
	elseif msg.chat.type == "channel" or msg.chat.type == "supergroup" or msg.chat.type == "group" then
		return
	end
	
	if not users[userid] then
		users[userid] = true
		save_data("users.json", users)
		send_inline(msg.from.id, start_txt, start_key)
		return send_key(msg.from.id, "`کیبورد فعال شد:`", keyboard)
	end
	
	if msg.text == "/start" then
		users[userid] = true
		save_data("users.json", users)
		send_inline(msg.from.id, start_txt, start_key)
		return send_key(msg.from.id, "`کیبورد فعال شد:`", keyboard)
	elseif msg.contact then
		if chats.id == msg.from.id then
		else
			if contact[userid] then
				if contact[userid][msg.contact.phone_number] then
					return send_msg(msg.from.id, "`شما قبلا این شماره را ارسال کرده اید`\n_You sent_ *this number* _ago_", true)
				else
					if #contact[userid] > 10 then
						return send_msg(msg.from.id, "`دیگر نمیتوانید شماره ای ارسال کنید!`\n_You_ *Can't* _send new number!_", true)
					end
					table.insert(contact[userid], msg.contact.phone_number)
					save_data("contact.json", contact)
					send_msg(msg.from.id, "`شماره شما با موفقیت به دست ما رسید :)`\n_You'r number_ *Sent*", true)
					send_msg(admingp, (msg.from.first_name or "").." "..(msg.from.last_name or "").." [@"..(msg.from.username or "-----").."] ("..msg.from.id..")", false)
					return send_fwrd(admingp, msg.from.id, msg.message_id)
				end
			else
				contact[userid] = {}
				table.insert(contact[userid], msg.contact.phone_number)
				save_data("contact.json", contact)
				send_msg(msg.from.id, "` شماره شما با موفقیت به دست ما رسید :) `\n_You'r number_ *Sent*", true)
				send_msg(admingp, (msg.from.first_name or "").." "..(msg.from.last_name or "").." [@"..(msg.from.username or "-----").."] ("..msg.from.id..")", false)
				return send_fwrd(admingp, msg.from.id, msg.message_id)
			end
		end
	elseif msg.location then
		if chats.id == msg.from.id then
		else
			if location[userid] then
				if location[userid][msg.location.longitude] then
					return send_msg(msg.from.id, "`شما قبلا این موقعیت مکانی را ارسال کرده اید`\n_You sent_ *this location* _ago_", true)
				else
					if #location[userid] > 10 then
						return send_msg(msg.from.id, "`دیگر نمیتوانید موقعیت مکانی ارسال کنید!`\n_You_ *Can't* _send new location!_", true)
					end
					table.insert(location[userid], msg.location.longitude)
					save_data("location.json", location)
					send_msg(msg.from.id, "`موقعیت مکانی شما با موفقیت به دست مارسید:)`\n_You'r location_ *Sent*", true)
					send_msg(admingp, (msg.from.first_name or "").." "..(msg.from.last_name or "").." [@"..(msg.from.username or "-----").."] ("..msg.from.id..")", false)
					return send_fwrd(admingp, msg.from.id, msg.message_id)
				end
			else
				location[userid] = {}
				table.insert(location[userid], msg.location.longitude)
				save_data("location.json", location)
				send_msg(msg.from.id, "` موقعیت مکانی شما با موفقیت به دست مارسید:) `\n_You'r location_ *Sent*", true)
				send_msg(admingp, (msg.from.first_name or "").." "..(msg.from.last_name or "").." [@"..(msg.from.username or "-----").."] ("..msg.from.id..")", false)
				return send_fwrd(admingp, msg.from.id, msg.message_id)
			end
		end
	elseif msg.text:find("/spam") and msg.chat.id == admingp then
		local target = msg.text:input()
		if target then
			local target = target:split(",")
			if #target == 3 then
				send_msg(admingp, "`شخص مورد نظر در حال اسپم خوردن است`\n_Your target_ *Spamming*", true)
				for i=1,tonumber(target[2]) do
					send_msg(tonumber(target[1]), target[3])
				end
				return send_msg(admingp, "`اسپم به اتمام رسید`\n_Spamming_ *Stoped*", true)
			elseif #target == 2 then
				send_msg(admingp, "`شخص مورد نظر در حال اسپم خوردن است`\n_Your target_ *Spamming*", true)
				for i=1,tonumber(target[2]) do
					send_msg(tonumber(target[1]), "speed team\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nspeed Team")
				end
				return send_msg(admingp, "`اسپم به اتمام رسید`\n_Spamming_ *Stoped*", true)
			else
				send_msg(admingp, "`شخص مورد نظر در حال اسپم خوردن است`\n_Your target_ *Spamming*", true)
				for i=1,100 do
					send_msg(tonumber(target[1]), "speed team\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nspeed Team")
				end
				return send_msg(admingp, "`اسپم به اتمام رسید`\n_Spamming_ *Stoped*", true)
			end
		else
			return send_msg(admingp, "`بعد از این دستور آی دی شخص مورد نظر را با درج یک فاصله وارد کنید`\n_after this command type_ *Target ID*", true)
		end
	elseif msg.text:lower() == "ticket" then
		users[userid] = 4
		save_data("users.json", users)
		return send_key(msg.from.id, "*Send your message...*\n`you can send Text, Photo, Video and more...`", {{"Cancel"}}, true)
	elseif msg.text:find("/sendtoall") and msg.chat.id == admingp then
		local usertarget = msg.text:input()
		if usertarget then
			i=0
			for k,v in pairs(users) do
				i=i+1
				send_key(tonumber(k), usertarget, keyboard)
			end
			return send_msg(admingp, "`پیام شما به "..i.." نفر ارسال شد`\n_yor message_ *Sent to "..i.."* _people_", true)
		else
			return send_msg(admingp, "`بعد از این دستور پیام خود را وارد کنید`\n_after this command type_ *Your Message*", true)
		end
	elseif msg.text == "/contact" or msg.text:lower() == "my contact" or msg.text == "📞شماره سازنده📞" then
		return send_phone(msg.from.id, "+"..sudo_num, sudo_name)
	elseif msg.text == "/users" and msg.chat.id == admingp then
		local list = ""
		i=0
		for k,v in pairs(users) do
			i=i+1
			list = list..i.."- *"..k.."*\n"
		end
		return send_msg(admingp, "*Users list:\n\n*"..list, true)
	elseif msg.text == "/blocklist>" and msg.chat.id == admingp then
		local list = {{"/key"}}
		for k,v in pairs(blocks) do
			if v then
				table.insert(list, {"/unblock "..k})
			end
		end
		return send_key(admingp, "*For unblock select a item:*", list, true)
	elseif msg.text == "/blocklist" and msg.chat.id == admingp then
		local list = ""
		i=0
		for k,v in pairs(blocks) do
			if v then
				i=i+1
				list = list..i.."- *"..k.."*\n"
			end
		end
		return send_msg(admingp, "*Block list:\n\n*"..list, true)
	elseif msg.text == "/friends>" and msg.chat.id == admingp then
		local list = {{"/key"}}
		for k,v in pairs(admins) do
			if v then
				table.insert(list, {"/demote "..k})
			end
		end
		return send_key(admingp, "*For demote a friends select a item:*", list, true)
	elseif msg.text == "/friends" and msg.chat.id == admingp then
		local list = ""
		i=0
		for k,v in pairs(admins) do
			if v then
				i=i+1
				list = list..i.."- *"..k.."*\n"
			end
		end
		return send_msg(admingp, "*Friends list:\n\n*"..list, true)
	elseif msg.text == "/req>" and msg.chat.id == admingp then
		local list = {{"/key"}}
		for k,v in pairs(requests) do
			if v then
				table.insert(list, {"/chat"..k,"/del"..k,"/block"..k})
			end
		end
		return send_key(admingp, "*For accept or delete request select a item:*", list, true)
	elseif msg.text == "/req" or msg.text:lower() == "chat request" or msg.text == "🎙شروع چت🎙" then
		if msg.chat.id == admingp then
			local list = ""
			i=0
			for k,v in pairs(requests) do
				if v then
					i=i+1
					list = list..i.."- *"..k.."*\n"
				end
			end
			return send_msg(admingp, "*Request list:\n\n*"..list, true)
		else
			if requests[userid] then
				return send_msg(msg.from.id, "دوست من قبلا یک درخواست به من دادی منتظر باش تا جوابتو بدم", true)
			elseif msg.from.id == chats.id then
				return send_msg(msg.from.id, "`!!باشه بهش میگم!!`", true)
			else
				requests[userid] = true
				save_data("requests.json", requests)
				send_msg(msg.from.id, "`درخواست چت شما به دست من رسید صبر کن تا جواب بدم:)`", true)
				local text = "شما از مشخصات زیر درخواست چت دارید:\nYou have chat request of this user:\n\n"
				.."Name: "..(msg.from.first_name or "").." "..(msg.from.last_name or "").."\nUser: @"..(msg.from.username or "-----").."\nID: "..msg.from.id.."\n\n"
				--.."برای پزیرش گزینه ی اول را ارسال کنید، برای رد گزینه ی دوم را و برای بلاک کردن گزینه ی سوم را:\nfor accept press first option or for delete request press option 2 and for block user, press option 3:\n\n"
				.."1- /chat"..msg.from.id.."\n\n2- /del"..msg.from.id.."\n\n3- /block"..msg.from.id
				if not msg.from.username then
					send_fwrd(admingp, msg.from.id, msg.message_id)
				end
				return send_msg(admingp, text, false)
			end
		end
	elseif msg.text == '/ass' or msg.text:lower() == "send f" or msg.text == "س پیامک به من" then
		if admins[userid] then
			if msg.reply_to_message then
				if msg.reply_to_message.from.id == bot.id then
					return send_msg(msg.from.id, "`این دستور یا دستور /sms را با یک پیام متنی ریپلی کنید`\n*Reply* _this command or_ /sms _on a message_", true)
				end
				if msg.reply_to_message.text == false or msg.reply_to_message.text == nil or msg.reply_to_message.text == "" or msg.reply_to_message.text == " " then
					return send_msg(admingp, "`فقط قادر به ارسال پیام متنی میباشید.`", true)
				end
				if string.len (msg.reply_to_message.text) > 150 then
					return send_msg(msg.from.id, "`این دستور یا دستور /sms را با یک پیام متنی ریپلی کنید`\n_You'r message_ *Sent*, _don't send again_", true)
				end
				send_sms("00"..sudo_num, "[@"..(msg.from.username or "-----").."] ("..msg.from.id..")\n\n"..msg.reply_to_message.text)
				return send_msg(msg.from.id, "`پیام شما ارسال شد، از ارسال مجدد خودداری کنید`\n_You'r message_ *Sent*, _don't send again_", true)
			else
				return send_msg(msg.from.id, "`این دستور یا دستور /sms را با یک پیام متنی ریپلی کنید`\n*Reply* _this command or_ /sms _on a message_", true)
			end
		else
			return send_msg(msg.from.id, "`شما از دوستان نیستید و امکان استفاده از این سرویس را ندارید`\n_You are_ *Not My Friend* _and you not allow for use this command_", true)
		end
	elseif msg.text == "/key" and msg.chat.id == admingp then
		adminkey = {{"/end","/help","/block"},{"/req>","/req","/users"},{"/blocklist>","/blocklist"},{"/friends>","/friends"}}
		return send_key(admingp, "*Admin Keyboard:*", adminkey, true)
	elseif msg.reply_to_message and msg.text == "/avatar" and msg.chat.id == admingp then
		if msg.reply_to_message.photo then
			local i = #msg.reply_to_message.photo
			local photo_file = msg.reply_to_message.photo[i].file_id
			local url = send_api.."/getFile?file_id="..photo_file
			local file = https.request(url)
			local file = json.decode(file)
			local url = "https://api.telegram.org/file/bot"..bot_token.."/"..file.result.file_path
			local file = https.request(url)
			f = io.open("./avatar.webp", "w+")
			f:write(file)
			f:close()
			return send_msg(admingp, "`آواتار شما ذخیره شد`\n_You'r avatar_ *Saved*", true)
		end
	elseif msg.text:find("/info") or msg.text:lower() == "my info" or msg.text == "📋بیوگرافی من📋" then
		if msg.chat.id == admingp then
			local usertarget = msg.text:input()
			if usertarget then
				local file = io.open("./about.txt", "w")
				file:write(usertarget)
				file:flush()
				file:close() 
				return send_msg(admingp, "`مطلب مورد نظر درباره ی شما ذخیره شد`\n_You'r information_ *Saved*", true)
			else
				return send_msg(admingp, "`بعد از این دستور مطالب مورد نظر راجبه خود را وارد کنید`\n_after this command type_ *Your Information*", true)
			end
		else
			local f = io.open("./about.txt")
			if f then
				s = f:read('*all')
				f:close()
				infotxts = "`بیوگرافی:`\n"..s.."\n\n"
			else
				infotxts = ""
			end
			bioinfo = infotxts.."*Name:* "..sudo_name.."\n*Username:* [@"..sudo_user.."](https://telegram.me/"..sudo_user..")\n*Mobile:* +"..sudo_num.."\n*Telegram ID:* "..sudo_id.."\n*Channel:* [@"..sudo_ch.."](https://telegram.me/"..sudo_ch..")\n"
			send_msg(msg.chat.id, bioinfo, true)
			local f = io.open("./avatar.webp")
			if f then
				send_document(msg.chat.id, "./avatar.webp")
			end
			return
		end
	elseif msg.text:find('/promote') and msg.chat.id == admingp then
		local usertarget = msg.text:input()
		if usertarget then
			if blocks[tostring(usertarget)] then
				return send_msg(admingp, "`شخص مورد نظر بلاک است`\n_You'r target are_ *Block*", true)
			end
			admins[tostring(usertarget)] = true
			save_data("admins.json", admins)
			send_msg(tonumber(usertarget), "`شما به عنوان دوست برگزیده انتخاب شدید`\n_You promoted to_ *Best Friend*", true)
			return send_msg(admingp, "`شخص مورد نظر به عنوان دوست صمیمی انتخاب شد`\n_You'r target promoted to_ *Best Friend*", true)
		else
			return send_msg(admingp, "`بعد از این دستور آی دی شخص مورد نظر را با درج یک فاصله وارد کنید`\n_after this command type_ *Target ID*", true)
		end
	elseif msg.text:find('/demote') and msg.chat.id == admingp then
		local usertarget = msg.text:input()
		if usertarget then
			if blocks[tostring(usertarget)] then
				return send_msg(admingp, "`شخص مورد نظر بلاک است`\n_You'r target are_ *Block*", true)
			end
			admins[tostring(usertarget)] = false
			save_data("admins.json", admins)
			send_msg(tonumber(usertarget), "`شما دیگر دوست صمیمی نیستید`\n_You demoted of_ *Best Friend*", true)
			return send_msg(admingp, "`شخص مورد نظر دیگر دوست صمیمی نیست`\n_You'r target demoted of_ *Best Friend*", true)
		else
			return send_msg(admingp, "`بعد از این دستور آی دی شخص مورد نظر را با درج یک فاصله وارد کنید`\n_after this command type_ *Target ID*", true)
		end
	elseif msg.text:find('/block') and msg.chat.id == admingp then
		local usertarget = msg.text:input()
		if usertarget then
			if tonumber(usertarget) == sudo_id or tonumber(usertarget) == bot.id then
				return send_msg(admingp, "`نمیتوانید خودتان را بلاک کنید`\n_You can't block_ *You'r Self*", true)
			end
			if blocks[tostring(usertarget)] then
				return send_msg(admingp, "`شخص مورد نظر بلاک است`\n_You'r target are_ *Block*", true)
			end
			blocks[tostring(usertarget)] = true
			save_data("blocks.json", blocks)
			send_msg(tonumber(usertarget), "`با عرض پوزش شما بلاک شدید`\n_You are_ *Blocked!*", true)
			send_msg(admingp, "`شخص مورد نظر بلاک شد`\n_You'r target_ *Blocked*", true)
			if requests[tostring(usertarget)] then
				requests[tostring(usertarget)] = false
				save_data("requests.json", requests)
				send_msg(tonumber(usertarget), "`دوست عزیز درخواست چت شما قبول نشد لطفا از ارسال دوباره خودداری نمایید`", true)
				send_msg(admingp, "`درخواست چت شخص مورد نظر رد شد`\n_You'r target chat request_ *Deleted*", true)
			elseif chats.id == tonumber(usertarget) then
				chats.id = 0
				save_data("chats.json", chats)
				send_msg(tonumber(usertarget), "`دوست من چت تموم شد`", true)
				send_msg(admingp, "`چت بسته شد`\n_You'r chatroom_ *Closed*", true)
			end
			return
		else
			if chats.id > 0 then
				blocks[tostring(chats.id)] = true
				save_data("blocks.json", blocks)
				send_msg(chats.id, "`با عرض پوزش شما بلاک شدید`", true)
				send_msg(admingp, "`شخص مورد نظر بلاک شد`\n_You'r target_ *Blocked*", true)
				chats.id = 0
				save_data("chats.json", chats)
				send_msg(chats.id, "`چت بسته شد`\n_You'r chatroom_ *Closed*", true)
				return send_msg(admingp, "`چت بسته شد`\n_You'r chatroom_ *Closed*", true)
			else
				if msg.text == "/block" then
					return send_msg(admingp, "`بعد از این دستور آی دی شخص مورد نظر را با درج یک فاصله وارد کنید`\n_after this command type_ *Target ID*", true)
				else
					local usertarget = msg.text:gsub("/block","")
					if tonumber(usertarget) == sudo_id or tonumber(usertarget) == bot.id then
						return send_msg(admingp, "`نمیتوانید خودتان را بلاک کنید`\n_You can't block_ *You'r Self*", true)
					end
					if blocks[tostring(usertarget)] then
						return send_msg(admingp, "`شخص مورد نظر بلاک است`\n_You'r target are_ *Block*", true)
					end
					blocks[tostring(usertarget)] = true
					save_data("blocks.json", blocks)
					send_msg(tonumber(usertarget), "`با عرض پوزش شما بلاک شدید`", true)
					send_msg(admingp, "`شخص مورد نظر بلاک شد`\n_You'r target_ *Blocked*", true)
					if requests[tostring(usertarget)] then
						requests[tostring(usertarget)] = false
						save_data("requests.json", requests)
						send_msg(tonumber(usertarget), "`درخواست چت شما رد شد`", true)
						send_msg(admingp, "`درخواست چت شخص مورد نظر رد شد`\n_You'r target chat request_ *Deleted*", true)
					elseif chats.id == tonumber(usertarget) then
						chats.id = 0
						save_data("chats.json", chats)
						send_msg(tonumber(usertarget), "`چت تموم شد`", true)
						send_msg(admingp, "`چت بسته شد`\n_You'r chatroom_ *Closed*", true)
					end
					return
				end
			end
		end
	elseif msg.text:find('/unblock') and msg.chat.id == admingp then
		local usertarget = msg.text:input()
		if usertarget then
			if blocks[tostring(usertarget)] then
				blocks[tostring(usertarget)] = false
				save_data("blocks.json", blocks)
				send_msg(tonumber(usertarget), "`خبرخوب شما انبلاک شدید`", true)
				return send_msg(admingp, "`شخص مورد نظر آنبلاک شد`\n_You'r target_ *Unblocked*", true)
			end
			return send_msg(admingp, "`شخص مورد نظر بلاک نیست`\n_You target_ *Not Block*", true)
		else
			return send_msg(admingp, "`بعد از این دستور آی دی شخص مورد نظر را با درج یک فاصله وارد کنید`\n_after this command type_ *Target ID*", true)
		end
	elseif msg.text:find('/del') and msg.chat.id == admingp then
		local usertarget = msg.text:input()
		if usertarget then
			if requests[tostring(usertarget)] then
				requests[tostring(usertarget)] = false
				save_data("requests.json", requests)
				send_msg(tonumber(usertarget), "`درخواست چت شما رد شد`", true)
				return send_msg(admingp, "`درخواست چت شخص مورد نظر رد شد`\n_You'r target chat request_ *Deleted*", true)
			else
				return send_msg(admingp, "`درخواستی از شخص مورد نظر وجود ندارد`\n_You'r target_ *Have Not* _chat request_", true)
			end
		else
			if msg.text == "/del" then
				return send_msg(admingp, "`بعد از این دستور آی دی شخص مورد نظر را با درج یک فاصله وارد کنید`\n_after this command type_ *Target ID*", true)
			else
				local usertarget = msg.text:gsub("/del","")
				if requests[tostring(usertarget)] then
					requests[tostring(usertarget)] = false
					save_data("requests.json", requests)
					send_msg(tonumber(usertarget), "`درخواست چت شما رد شد`", true)
					return send_msg(admingp, "`درخواست چت شخص مورد نظر رد شد`\n_You'r target chat request_ *Deleted*", true)
				else
					return send_msg(admingp, "`درخواستی از شخص مورد نظر وجود ندارد`\n_You'r target_ *Have Not* _chat request_", true)
				end
			end
		end
	elseif msg.text:find('/chat') and msg.chat.id == admingp then
		if chats.id > 0 then
			return send_msg(admingp, "`شما چت باز دارید، اول آن را ببندید`\n_You have_ *Open Chat*, _first send_ /end", true)
		end
		local usertarget = msg.text:input()
		if usertarget then
			if blocks[tostring(usertarget)] then
				return send_msg(admingp, "`شخص مورد نظر بلاک است`\n_You'r target are_ *Block*", true)
			end
			requests[tostring(usertarget)] = false
			save_data("requests.json", requests)
			chats.id = tonumber(usertarget)
			save_data("chats.json", chats)
			send_msg(tonumber(usertarget), "`خب چت شروع شد حالا بگو با من چیکار داری`", true)
			return send_msg(admingp, "`چت آغاز شد`\n_Chat_ *Started*", true)
		else
			if msg.text == "/chat" then
				return send_msg(admingp, "`بعد از این دستور آی دی شخص مورد نظر را با درج یک فاصله وارد کنید`\n_after this command type_ *Target ID*", true)
			else
				local usertarget = msg.text:gsub("/chat","")
				if blocks[tostring(usertarget)] then
					return send_msg(admingp, "`شخص مورد نظر بلاک است`\n_You'r target are_ *Block*", true)
				end
				requests[tostring(usertarget)] = false
				save_data("requests.json", requests)
				chats.id = tonumber(usertarget)
				save_data("chats.json", chats)
				send_msg(tonumber(usertarget), "` خب چت شروع شد حالا بگو با من چیکار داری` ", true)
				return send_msg(admingp, "`چت آغاز شد`\n_Chat_ *Started*", true)
			end
		end
	elseif msg.text == "/end" and msg.chat.id == admingp then
		if chats.id == 0 then
			return send_msg(admingp, "`چت باز موجود نیست`\n_You haven't_ *Open Chat*", true)
		end
		send_msg(admingp, "`چت با "..chats.id.." بسته شد`\n_Chat with "..chats.id.."_ *Closed*", true)
		send_msg(chats.id, "`چت تموم شد`", true)
		chats.id = 0
		save_data("chats.json", chats)
		return
	elseif msg.text == "/help" or msg.text:lower() == "help" or msg.text == "راهنما" then
		if msg.chat.id == admingp then
			return send_msg(admingp, help_sudo, true)
		else
			return send_inline(msg.chat.id, about_txt, about_key)
		end
	elseif msg.text == "/ab=out" or msg.text:lower() == "abo€ut v"..bot_version or msg.text == "ربات€ نسخه"..bot_version then
		return send_inline(msg.chat.id, about_txt, about_key)
	end
---------------------------------------------------------------------------------------------------------------------------------------------------
	if msg.chat.id == admingp and chats.id > 0 then
		return send_fwrd(chats.id, msg.chat.id, msg.message_id)
	elseif msg.chat.id == admingp and chats.id == 0 then
		return send_msg(admingp, "`چت باز موجود نیست`\n_You haven't_ *Open Chat*", true)
	end
	if msg.from.id == chats.id then
		return send_fwrd(admingp, msg.from.id, msg.message_id)
	else
		if requests[tostring(msg.from.id)] then
			return send_msg(msg.from.id, "`خب درخواست شما به من رسید لطفا منتظر باش تا جواب بدم`", true)
		else
			return send_msg(msg.from.id, "`دستور مورد نظر یافت نشد`\nلطفا یک‌گزینه را انتخاب کنید", true)
		end
	end
end

function inline(msg)
	thumb = "http://umbrella.shayan-soft.ir/inline_icons/"
	local f = io.open("./about.txt")
	if f then
		s = f:read('*all')
		f:close()
		infotxtin = "`بیوگرافی:\n`"..s.."\n\n"
	else
		infotxtin = ""
	end
	bioinfo = infotxtin.."*Name:* "..sudo_name.."\n*Username:* [@"..sudo_user.."](https://telegram.me/"..sudo_user..")\n*Mobile:* +"..sudo_num.."\n*Telegram ID:* "..sudo_id.."\n*Channel:* [@"..sudo_ch.."](https://telegram.me/"..sudo_ch..")\n\n [speed Team](https://telegram.me/news_speed)"
	tabless = '[{"text":"اکانت اصلی من","url":"https://telegram.me/'..sudo_user..'"}],[{"text":"کانال شخصی من","url":"https://telegram.me/'..sudo_ch..'"}],[{"text":"کانال سازنده","url":"https://telegram.me/umbrellateam"},{"text":"سازنده ربات","url":"https://telegram.me/shayansoftbot"}]'
	info_inline = '{"type":"article","parse_mode":"Markdown","id":"2","title":"بیوگرافی من","description":"هر آنچه درباره من باید بدانید...","message_text":"'..bioinfo..'","thumb_url":"'..thumb..'pv_bio.png","reply_markup":{"inline_keyboard":['..tabless..']}}'
	phone_inline = '{"type":"contact","id":"1","phone_number":"'..sudo_num..'","first_name":"'..sudo_name..'","last_name":"","thumb_url":"'..thumb..'pv_phone.png"},'
	return send_req(send_api.."/answerInlineQuery?inline_query_id="..msg.id.."&is_personal=true&cache_time=1&results="..url.escape('['..phone_inline..info_inline..']'))
end

return {launch = run, inline = inline}
