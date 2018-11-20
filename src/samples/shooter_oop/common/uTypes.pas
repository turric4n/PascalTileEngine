{******************************************************************************
*
* Pascal Tilengine horizontal shooter sample (OOP aproach)
* Copyright (c) 2018 coversion by Enrique Fuentes (aka Turric4n) - thanks to
* Marc Palacios for this great project.
* http://www.tilengine.org
*
* Complete game example, horizontal scrolling, actors, collisions... OOP
*
******************************************************************************}

unit uTypes;

interface

const
  MAX_BULLETS = 20;
  MAX_ENEMIES = 10;

type
  TLayerType = (ltForeground, ltBackground, ltMax);
  TSpritesetType = (ssMain, ssHellArm, ssMax);
  TActorType = (atShip = 1, atClaw, atBladeB, atBlades, atEnemy, atExplosion);
  TActorDef = (acShip, acClaw1, acClaw2, acEnemy1, acBoss = acEnemy1 + MAX_ENEMIES, acBullet1 = acBoss + 8, acMAX = acBullet1 + MAX_BULLETS);
  TActorAnim = (aaClaw, aaBlade1, aaBlade2, aaExpl01, aaExpl02, aacMax);

  TRect = record
    x1 : Integer;
    y1 : Integer;
    x2 : Integer;
    y2 : Integer;
  end;

  TCollisionEvent = procedure(aSender : TObject; Power : Integer) of object;
  THitEvent = procedure(aSender : TObject; Power : Integer) of object;
  TProcessEvent = procedure(aSender : TObject; Time : Word) of object;

implementation

end.
