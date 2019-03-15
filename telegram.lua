local teleTok   = 'Enter your Bot Token here'
local snapFile  = '/home/pi/domoticzSnap'
local domoReq   = 'http://localhost:8080/camsnapshot.jpg?idx='
local tgAb = {}
tgAb['myName1']     = 222222222
tgAb['myName2']     = 111111111
tgAb['myGroup'] = -00000000

local telegram ={};

    function telegram.getId(nome)
        return tgAb[nome]
    end
    
    function telegram.sendText(chatId, message)
        return os.execute('curl --data chat_id='..chatId..' --data parse_mode=Markdown --data-urlencode "text='..message..'"  "https://api.telegram.org/bot'..teleTok..'/sendMessage" ')
    end

    function telegram.sendImage(chatId, camChannel)
        os.execute('wget -O "'..snapFile..camChannel..'.jpg" "'..domoReq..camChannel..'"')
        return os.execute('curl -s -X POST "https://api.telegram.org/bot'..teleTok..'/sendPhoto?chat_id='..chatId..'" -F photo="@'..snapFile..camChannel..'.jpg"')
    end

    function telegram.sendDoc(chatId, filePath)
        return os.execute('curl -s -X POST "https://api.telegram.org/bot'..teleTok..'/sendDocument?chat_id='..chatId..'" -F document="@'..filePath..'"')
    end

    function telegram.sendMG(chatId, arrPic)
-- Array to provide:
-- local arrPic = {{'photo', 'attach:///home/pi/snap1.jpg', 'Test', 'Markdown'},{'photo', 'attach:///home/pi/temp/snap.jpg', 'Test', 'Markdown'}}
        local strMedia = ''
        local strPics = ''
        if type(arrPic) == 'table' then
            for idx = 1, #arrPic do
                if arrPic[idx][2]:sub(1,9) == "attach://" then  -- Local file
                    strPics = strPics..' -F '..arrPic[idx][1]..'_'..idx..'=@'..arrPic[idx][2]:sub(10)
                    strMedia = strMedia..'{"type":"'..arrPic[idx][1]..'","media":"attach://'..arrPic[idx][1]..'_'..idx..'","caption":"'..arrPic[idx][3]..'","parse_mode":"'..arrPic[idx][4]..'"}'
                else
                    strMedia = strMedia..'{"type":"'..arrPic[idx][1]..'","media":"'..arrPic[idx][2]..'","caption":"'..arrPic[idx][3]..'","parse_mode":"'..arrPic[idx][4]..'"}'
                end
                if idx ~= #arrPic then
                    strMedia = strMedia..','
                end
            end
            return os.execute('curl -X POST https://api.telegram.org/bot'..teleTok..'/sendMediaGroup?chat_id='..chatId..' '..strPics..' -F media=\'['..strMedia..']\'')
        end
    end

return telegram     
 
