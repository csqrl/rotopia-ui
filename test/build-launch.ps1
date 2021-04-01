foreman install
rojo build .\build.project.json -o .\test\TestPlace.rbxlx
Invoke-Item .\test\TestPlace.rbxlx
rojo serve .\build.project.json
