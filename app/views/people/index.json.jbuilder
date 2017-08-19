json.array!(@followers) do |p|
  json.name p.username
  json.id p.id
end