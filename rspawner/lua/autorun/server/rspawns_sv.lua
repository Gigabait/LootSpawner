rspawns = rspawns or {}
rspawns.spawners = {}
rspawns.spawned = {}
function rspawns.Register(pos,class,time)
local a = {pos,class,time}
for k,v in pairs(rspawns.spawners) do
if v[1] == pos and v[2] == class and v[3] == time then
return
end
end
print("[rSpawn] Registered " .. class .. " at " .. tostring(pos) .. " spawning every " .. time .. " seconds!")
table.insert(rspawns.spawners,a)
local k = #rspawns.spawners
timer.Create("rspawns" .. tostring(k),time,0,function()
if #player.GetAll() < 1 then return end
if not rspawns.spawners[k] then return end
if rspawns.spawned[k] then
if IsValid(rspawns.spawned[k]) then
if rspawns.spawned[k]:GetOwner() then
if IsValid(rspawns.spawned[k]:GetOwner()) then
rspawns.spawned[k] = nil
else
return
end
end
end
end
local a = ents.Create(class)
if not a then
for k,v in pairs(player.GetAll()) do
if v:IsAdmin() then
v:ChatPrint("[Rspawner]: Could not spawn entity '" .. class .. "'! It might not exist on the server!")
return -- too lazy to fix this return lmao
end
end
end
a:SetPos(pos)
a:Spawn()
rspawns.spawned[k] = a

end)
end

concommand.Add("rspawn",function(a)
local e = a:GetEyeTrace().Entity
if not IsValid(e) then
a:ChatPrint("Look at a valid entity!")
return
end
local pos = e:GetPos()
a:ChatPrint([[rspawns.Register(Vector(]] .. pos.x .. "," .. pos.y .. "," .. pos.z .. '),"' .. e:GetClass() .. '",60)')
a:ChatPrint("Please change 60 to the interval you want on the spawner (In seconds.)")
end)

hook.Add("InitPostEntity","RSpawnsInit",function()
rspawns.init = true
end)

print("Loading rspawns config.")
include("rspawns.lua")
print("Loaded!")
