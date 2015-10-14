return {
  version = "1.1",
  width = 50,
  height = 25,
  tilewidth = 64,
  tileheight = 32,
  tileset = {
      image = "tileset_64x48_4.png",
      imagewidth = 128,
      imageheight = 48,
      tilewidth = 64,
      tileheight = 48,
      tilecount = 4,
      tileoffset = { x = 0, y = 0 },
      spacing = 0,
      margin = 0
  },
  layers = {
    {
      name = "Ground",
      data = {
          2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
          2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
          2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
          4,4,4,3,3,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
          4,4,4,3,3,3,3,1,1,1,1,1,1,1,1,1,2,2,2,2,2,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
          4,4,4,3,3,3,3,3,1,1,1,1,1,1,1,1,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
          4,4,4,3,3,3,3,3,3,1,1,1,1,1,1,1,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
          4,4,4,3,3,3,3,3,3,3,1,1,1,1,1,1,2,2,2,2,2,2,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
          4,4,4,3,3,3,3,3,3,3,1,1,1,1,1,1,2,2,2,2,2,2,1,1,1,2,2,2,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
          4,4,4,3,3,3,3,3,3,3,1,1,1,1,1,1,2,2,2,2,2,2,1,1,1,2,2,2,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
          4,4,4,3,3,3,3,3,3,3,1,1,1,1,1,1,2,2,2,2,2,2,2,1,1,2,2,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
          4,4,4,3,3,3,3,3,3,3,1,1,1,1,1,1,2,2,2,2,2,2,2,1,1,2,2,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
          4,4,4,3,3,3,3,3,3,3,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,
          4,4,4,3,3,3,3,3,3,3,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,
          4,4,4,3,3,3,3,3,3,3,1,1,1,1,1,1,2,2,2,2,2,2,2,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,
          4,4,4,3,3,3,3,3,3,3,1,1,1,1,1,1,2,2,2,2,2,2,2,1,1,1,4,4,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,
          4,4,4,3,3,3,3,3,3,3,1,1,1,1,1,1,2,2,2,2,2,2,2,1,1,1,4,4,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,
          4,4,4,3,3,3,3,3,3,3,1,1,1,1,1,1,2,2,2,2,2,2,1,1,1,1,4,4,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,
          4,4,4,3,3,3,3,3,3,1,1,1,1,1,1,1,2,2,2,2,2,2,1,1,1,4,4,4,4,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,
          4,4,4,3,3,3,3,3,1,1,1,1,1,1,1,1,2,2,2,2,2,2,1,1,4,4,4,4,4,4,1,1,4,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,
          4,4,4,3,3,3,3,1,1,1,1,1,1,1,1,1,2,2,2,2,2,1,1,1,4,4,4,4,4,4,4,4,4,4,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,
          4,4,4,3,4,4,4,4,1,1,1,1,1,1,1,1,2,2,2,1,1,4,4,4,4,4,4,4,4,2,4,4,4,2,2,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,
          2,2,4,4,4,2,4,4,4,4,2,2,2,2,2,2,2,2,2,4,4,4,4,4,4,4,4,4,4,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
          2,2,2,2,2,2,2,2,2,2,4,4,4,2,2,2,2,2,2,4,4,4,4,4,4,4,4,4,4,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
          2,2,2,2,2,2,2,2,2,2,2,2,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
      }
    }
  }
}
