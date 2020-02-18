require("tmysql4")

include("sv_config.lua")

if Config == nil then
    Msg("\n\n\nHi there! Looks like the 'sv_config.lua' file is missing!\n")
    Msg("Please copy 'sv_config.example.lua', add your info, and rename it to 'sv_config.lua' and place it in the 'fortwars/gamemode' folder. K THX.\n\n\n")
end

DB = {}
DB.MySql = {}
DB.QueryQueue = {}
DB.NextQuery = CurTime() + 0.1
DB.FirstConnect = true
DB.Connected = false
DB.Host = Config.DB.Host
DB.Database = Config.DB.Database
DB.Port = Config.DB.Port
DB.Username = Config.DB.Username
DB.Password = Config.DB.Password

DB.Bundle = {}
DB.Bundle.Bundling = false
DB.Bundle.Template = ""
DB.Bundle.Type = ""
DB.Bundle.Count = 0
DB.Bundle.Data = {}

DB.PrintLog = false

DB.PrintQuerys = false
DB.LogQuerys = false

DB.QueriesPerMinute = 0

if not file.Exists("sh_sql_log.txt","DATA") then
	file.Write("sh_sql_log.txt","")
end

function DB.Connect()
    if not DB.IsConnected() then
        DB.MySql, err = tmysql.initialize(DB.Host,DB.Username,DB.Password,DB.Database,DB.Port)
        if DB.MySql and DB.FirstConnect then
            DB.Log("[MySQL Msg] First connect")
            timer.Simple(1,DB.Setup)
            DB.FirstConnect = false
            DB.Log("[MySQL Msg] Connected")
			DB.Connected = true
        end
        if err then
            DB.Log("[MySQL Database Error] "..tostring(err))
			DB.Connected = false
		end
        DB.Log("[MySQL Msg] Connecting...")
    end
end

function DB.StartBundle()
	DB.Log("[MySQL Msg] Bundling started")
	DB.Bundle.Bundling = true

	DB.Bundle.Template = ""
	DB.Bundle.Type = ""
	DB.Bundle.Count = 0
	DB.Bundle.Data = {}
end

function DB.AddToBundle(tQuery)
	local query = tQuery.sql

	if query:find("INSERT INTO") then
		DB.Bundle.Type = "INSERT INTO"
	elseif query:find("DELETE FROM") then
		DB.Bundle.Type = "DELETE FROM"
	end

	--Generate template if it doesn's exist
	if DB.Bundle.Template == "" then
		DB.Log("[MySQL Msg] Building bundle template for query type "..DB.Bundle.Type)

		if DB.Bundle.Type == "INSERT INTO" then --inserting query
			--Isolate ODKU
			if query:find("ON DUPLICATE KEY UPDATE") then
				DB.Bundle.Data.ODKU = query:gsub(".*(ON DUPLICATE KEY UPDATE.*)","%1")
				query = query:gsub("ON DUPLICATE KEY UPDATE.*","")
			end

			--Isolate the base of the query
			DB.Bundle.Data.Base = query:gsub(" VALUES%(.-%)",""):gsub(" $","")

			--Isolate the values
			local values = query:gsub(".*(VALUES%(.-%))","%1"):gsub(" $","")
			--Mark strings and numbers and clean up
			values = values:gsub("'.-'","'.-'"):gsub("%d+","%%d+"):gsub(" $","")

			--Build and clean up template
			DB.Bundle.Template = DB.Bundle.Data.Base.." "..values.." "..DB.Bundle.Data.ODKU
			DB.Bundle.Template = DB.Bundle.Template:gsub("%(","%%("):gsub("%)","%%)")

			--Add ODKU back to the end of the query
			query = query..DB.Bundle.Data.ODKU
		elseif DB.Bundle.Type == "DELETE FROM" then --deleting query
			--Isolate the base of query
			DB.Bundle.Data.Base = query:gsub("(.-WHERE).+","%1")

			--Isolate the condition structure and mark strings and numbers
			local conditions = query:gsub(".-WHERE (.+)","%1"):gsub("'.-'","'.-'"):gsub("%d+","%%d+")

			--Build the template
			DB.Bundle.Template = DB.Bundle.Data.Base.." "..conditions
		else
			error("Unknown query type; cannot build template")
		end

		DB.Log("[MySQL Msg] Bundle template generated")
	end

	if query:match(DB.Bundle.Template) then
		if DB.Bundle.Type == "INSERT INTO" then
			--Look for and isolate the values in the query
			local values = query:gsub("ON DUPLICATE KEY UPDATE.*",""):gsub(".-VALUES(%(.-%))","%1"):gsub(" $","")
			if not DB.Bundle.Data.Values then DB.Bundle.Data.Values = {} end

			--Add the isolated values to a table
			table.insert(DB.Bundle.Data.Values, values)
		elseif DB.Bundle.Type == "DELETE FROM" then
			--Isolate the conditions from the query
			local conditions = query:gsub(".-WHERE (.+)","%1")
			if not DB.Bundle.Data.Conditions then DB.Bundle.Data.Conditions = {} end

			--Add the isolated conditions to a table
			table.insert(DB.Bundle.Data.Conditions,"("..conditions..")")
		end

		--Add to bundle counter
		DB.Bundle.Count = DB.Bundle.Count + 1
	else
		error("Query doesn't match template!")
	end
end

function DB.EndBundle()
	DB.Log("[MySQL Msg] Bundling ended, bundled "..DB.Bundle.Count.." queries. Executing...")
	DB.Bundle.Bundling = false
	
	if DB.Bundle.Type == "INSERT INTO" then
		--If there are any queries in the bundle
		if DB.Bundle.Data.Values and table.Count(DB.Bundle.Data.Values) > 0 then
			--Build a query from the data we isolated
			DB.Query({sql=DB.Bundle.Data.Base.." VALUES "..table.concat(DB.Bundle.Data.Values, ",").." "..DB.Bundle.Data.ODKU})
		end
	elseif DB.Bundle.Type == "DELETE FROM" then
		--If there are any queries in the bundle
		if DB.Bundle.Data.Conditions and table.Count(DB.Bundle.Data.Conditions) > 0 then
			--Build a query from the data
			DB.Query({sql=DB.Bundle.Data.Base.." "..table.concat(DB.Bundle.Data.Conditions," OR ")})
		end
	end

	DB.Bundle.Template = ""
	DB.Bundle.Type = ""
	DB.Bundle.Count = 0
	DB.Bundle.Data = {}
end

function DB.Query(tQuery)
    if type(tQuery) != "table" or (not tQuery.sql) then error("Query is in invalid format!") end
    if DB.IsConnected() then
    	if DB.Bundle.Bundling then
    		if tQuery.callback then
    			error("Cannot bundle queries with callback!")
    		end
    		DB.AddToBundle(tQuery)
    		return
    	end

    	local call = function(results, status)
			local affected, data, lastid, status2, time, errorz = status[1].affected, status[1].data, status[1].lastid, status[1].status, status[1].time, status[1].error
		    if status2 then
				if tQuery.callback then
					tQuery.callback(data, lastid)
				end
			else
				MsgC(Color(255,0,0), errorz, " SQL Query: ",tQuery.sql)
				table.insert(DB.QueryQueue, tQuery)
				DB.NextQuery = CurTime() + 10
				DB.Connected = DB:IsConnected()
			end
	    end

        DB.Log("[MySQL Query] "..tQuery.sql)
        DB.MySql:Query(tQuery.sql, call, 1)
    else
		DB.Log("[MySQL Error] Database Is Connected: "..tostring(DB.IsConnected()))
    end
end

function DB.Escape(str) --for convinience :)
	return DB.MySql:Escape(str)
end

hook.Add("Think","SHDatabase",function()
	if CurTime() > DB.NextQuery then
		if DB.IsConnected() then
			DB.NextQuery = CurTime() + 0.1
			if DB.QueryQueue[1] then
				DB.Query(DB.QueryQueue[1])
				table.remove(DB.QueryQueue,1)
				DB.QueriesPerMinute = DB.QueriesPerMinute + 1
			end
		else
			DB.NextQuery = CurTime() + 10
			DB.Log("[MySQL Error] Tried to run a query but database is not connected, retrying in 10 seconds.("..(#DB.QueryQueue).." in queue)")
		end
	end
end)

function DB.IsConnected()
    if not DB.FirstConnect then
		return DB.Connected
    else
        return false
    end
end

function DB.CalcQueriesPerMinute()
	if DB.QueriesPerMinute > 0 then
		DB.Log("[MySQL Msg] Queries per minute: "..DB.QueriesPerMinute)
	end
    DB.QueriesPerMinute = 0
    if not DB.IsConnected() then
        DB.Connect()
    end
end
timer.Create("DBCalcQueriesPerMinute",60,0,DB.CalcQueriesPerMinute)

function DB.Setup()
	DB.Log("[MySQL Msg] Checking / Creating Tables")

	DB.Query{sql=[[
	CREATE DATABASE IF NOT EXISTS StrongHold;
	]]}

	DB.Query{sql=[[
	CREATE TABLE IF NOT EXISTS equip (
	`steamid` varchar(255) NOT NULL,
	`loadout` text,
	`lastequip` text,
	PRIMARY KEY (`steamid`));
	]]}

	DB.Query{sql=[[
	CREATE TABLE IF NOT EXISTS `items` (
	`steamid` varchar(255) NOT NULL,
	`item` varchar(255) NOT NULL,
	`itemstats` text NOT NULL,
	PRIMARY KEY (`steamid`,`item`));
	]]}

	DB.Query{sql=[[
	CREATE TABLE IF NOT EXISTS `licenses` (
	`steamid` varchar(255) NOT NULL,
	`slot` int(11) NOT NULL,
	`items` varchar(255) NOT NULL,
	`stat` varchar(255) DEFAULT NULL,
	PRIMARY KEY (`steamid`,`slot`,`items`));
	]]}

	DB.Query{sql=[[
	CREATE TABLE IF NOT EXISTS `stats` (
	`steamid` varchar(255) NOT NULL,
	`money` varchar(255) DEFAULT 1000,
	`reloads` varchar(255) DEFAULT NULL,
	`propsdestroyed` varchar(255) DEFAULT NULL,
	`bulletshit` varchar(255) DEFAULT NULL,
	`gbuxmoneyearned` varchar(255) DEFAULT NULL,
	`longestalive` varchar(255) DEFAULT NULL,
	`kills` varchar(255) DEFAULT NULL,
	`steps` varchar(255) DEFAULT NULL,
	`name` varchar(255) DEFAULT NULL,
	`dmginflicted` varchar(255) DEFAULT NULL,
	`deaths` varchar(255) DEFAULT NULL,
	`dmgtaken` varchar(255) DEFAULT NULL,
	`jumps` varchar(255) DEFAULT NULL,
	`crouches` varchar(255) DEFAULT NULL,
	`gbuxhighestmul` varchar(255) DEFAULT NULL,
	`propsplaced` varchar(255) DEFAULT NULL,
	PRIMARY KEY (`steamid`));
	]]}
end

function DB.Reset()
	DB.Log("[MySQL Msg] Dropping Tables")
	DB.Query{sql="DROP TABLE players"}
end

function DB.Clear()
	DB.Log("[MySQL Msg] Clearing Tables")
	DB.Query{sql="TRUNCATE TABLE players"}
end

function DB.Log(msg)
	if string.sub(msg,0,13) == "[MySQL Query]" then
		if DB.LogQuerys then
			file.Append("sh_sql_log.txt","["..os.date().."]"..msg.."\n")
		end
		if DB.PrintQuerys then
			MsgN("[StrongHold]"..msg)
		end
	else
		if DB.PrintLog then
			MsgN("[StrongHold]"..msg)
		end
		file.Append("sh_sql_log.txt","["..os.date().."]"..msg.."\n")
	end
end

DB.Connect()