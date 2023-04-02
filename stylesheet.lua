local Color = require 'color'

local function mkColor(r, g, b, a)
	if type(r) == 'table' then
		r, g, b, a = unpack(r)
	end

	return Color:new(r / 255, g / 255, b / 255, a and a / 255)
end

return {
  colors = {
    white = mkColor(255, 255, 255),
    black = mkColor(0, 0, 0),
  },

  background = {
    starColor = mkColor(255, 255, 255)
  },

  beams = {
    Laser = { color = mkColor(255, 255, 255) }
  },

  enemies = {
    Firewall = { color = mkColor(255, 0, 0) },

    MaskedTriCell = {
      bgColor = mkColor(6, 6, 6),
      lineColor = mkColor(32, 26, 22),
    },

    OneCell = { color = mkColor(255, 0, 0) },

    OneCellBlocker = { color = mkColor(176, 111, 26) },

    QuadCell = {
      bgColor = mkColor(163, 0, 0),
      lineColor = mkColor(240, 144, 0)
    },

    QuadCellBlocker = { color = mkColor(176, 111, 26) },

    QuadComposite = {
      outlineColor = mkColor(255, 66, 66),
      bodyColor = mkColor(250, 122, 30),
      inlineColor = mkColor(201, 84, 0)
    },

    QuintCell = {
      quadBgColor = mkColor(163, 0, 0),
      quadLineColor = mkColor(240, 144, 0),
      towerBgColor = mkColor(163, 0, 0),
      towerLineColor = mkColor(240, 144, 0)
    },

    Speeder = { color = mkColor(255, 162, 0) },

    TriCell = {
      bgColor = mkColor(163, 0, 0),
      lineColor = mkColor(240, 144, 0)
    },

    TwinCell = {
      bgColor = mkColor(196, 0, 0),
      lineColor = mkColor(255, 79, 15)
    }
  },

  friendlies = {
    Firewall = { color = mkColor(255, 255, 255) },

    QuadComposite = {
      outlineColor = mkColor(255, 255, 255),
      bgColor = mkColor(174, 207, 202),
      inlineColor = mkColor(199, 255, 247)
    }
  },

  player = {
    normalColor = mkColor(255, 255, 255),

    invulnerableColor = mkColor(200, 145, 255),

    shield = {
      baseColor = mkColor(0, 255, 248),
      secondaryColor = mkColor(168, 250, 244),
      thirdColor = mkColor(186, 255, 250),
      superColor = mkColor(255, 237, 36),
    },

    quadDamageProjectileColor = mkColor(88, 247, 59),

    quadDamageMissileColor = mkColor(178, 252, 164),
  },

  projectiles = {
    Bullet = {
      baseColor = mkColor(249, 255, 64)
    },

    Shell = {
      baseColor = mkColor(255, 255, 224)
    }
  },

  missiles = {
    Direct = { baseColor = mkColor(228, 233, 235) },

    Guided = { baseColor = mkColor(228, 233, 235) },
  },

  explosions = {
    Simple = {
      baseColor = mkColor(255, 230, 105),
      enemyBaseColor = mkColor(250, 98, 67),
    },
  },

  powerups = {
    Cannon = {
      bgColor = mkColor(148, 154, 156),
      fontColor = mkColor(0, 0, 0),
    },

    Firewall = {
      bgColor = mkColor(255, 255, 255),
      fontColor = mkColor(0, 0, 0),
    },

    Invulnerability = {
      bgColor = mkColor(200, 145, 255),
      fontColor = mkColor(0, 0, 0),
    },

    Life = {
      bgColor = mkColor(255, 255, 255),
      fontColor = mkColor(0, 0, 0),
    },

    MachineGun = {
      bgColor = mkColor(148, 154, 156),
      fontColor = mkColor(0, 0, 0),
    },

    Magnet = {
      bgColor = mkColor(145, 2, 227),
      fontColor = mkColor(255, 255, 255),
      activeColor = mkColor(145, 2, 227)
    },

    DirectMissile = {
      bgColor = mkColor(210, 215, 217),
      fontColor = mkColor(0, 0, 0),
    },

    GuidedMissile = {
      bgColor = mkColor(210, 215, 217),
      fontColor = mkColor(0, 0, 0),
    },

    QuadDamage = {
      bgColor = mkColor(88, 257, 59),
      fontColor = mkColor(0, 0, 0),
    },

    Reinforcement = {
      bgColor = mkColor(255, 255, 255),
      fontColor = mkColor(0, 0, 0),
    },

    Shield = {
      bgColor = mkColor(0, 255, 238),
      fontColor = mkColor(0, 0, 0),
    },

    SuperShield = {
      bgColor = mkColor(255, 237, 36),
      fontColor = mkColor(0, 0, 0),
    },
  },
}
