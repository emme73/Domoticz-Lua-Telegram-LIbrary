local arrPic = {}
-- Minumim
arrPic[1] = {"type":"<type>", "media":"{attach://<pathToPic> | http://<picUrl>}", "caption":"Comment", "parse_mode":"{Markdown | HTML}"}
arrPic[2] = {"type":"<type>", "media":"{attach://<pathToPic> | http://<picUrl>}", "caption":"Comment", "parse_mode":"{Markdown | HTML}"}
-- you can add up to 10
-- ALWAYS USE SEQUENTIAL STEPS... DO NOT JUMP FROM 2 to 5, 7 AND SO ON
-- arrPic[3] = {"type":"<type>", "media":"[attach://<pathToPic> | http://<picUrl>", "caption":"Comment", "parse_mode":"{Markdown | HTML}"}
-- etc. etc....

telegram.sendMG(chat_id, arrPic)


====== UNDER TELEGRAM FUNCTION LIBRARY

    function telegram.sendMG(chatId, arrPic)
		if type(arrPic) == 'table' then
			local strMedia = ''
			local strPics  = ''
			
			for idx = 1 to #arrPic 
				if arrPic[idx]["media"].sub(1,9) = "attach://" then 	-- Local file
					strPics = strPics..' -F '..arrPic[idx]["type"]..'_'..idx..'=@'..arrPic[idx]["media"].sub(10)
					strMedia = steMedia..'{"type":"'..arrPic[idx]["type"]..'","media":"attach://'..arrPic[idx]["type"]..'_'..idx..'","caption":"'..arrPic[idx]["caption"]..'","parese_mode":"'..arrPic[idx]["parse_mode"]..'"}'
				else
					strMedia = steMedia..'{"type":"'..arrPic[idx]["type"]..'","media":"'..arrPic[idx]["media"]..'","caption":"'..arrPic[idx]["caption"]..'","parese_mode":"'..arrPic[idx]["parse_mode"]..'"}'
				end 
				if idx ~= #arrPic then 
					steMedia = steMedia..','
				end 
			end for 
		else
			return false 
		end 
        return os.execute('curl -s -X POST "https://api.telegram.org/bot'..teleTok..'/sendMediaGroup?chat_id='..chatId..' '..strPics..' -F media="['..strMedia..']')
    end
	
