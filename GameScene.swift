import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let player = SKNode.init();
    let playerSprite = SKSpriteNode(imageNamed: "player");
    let playerParticle = SKEmitterNode(fileNamed: "water")!;
    let playerPhysicsBody = SKPhysicsBody(circleOfRadius: 30);
    let zaWarudo = SKPhysicsWorld.init();
    let pointLabel = SKLabelNode(text: "");
    let healthLabel = SKLabelNode(text: "");
    
    var control = false;
    var announcementLabel = SKLabelNode.init();
    var worldSpeed: Double = 3;
    var currentObstacle: SKSpriteNode = SKSpriteNode.init();
    var currentPoint = SKSpriteNode.init();
    var health = 3;
    var points = 0;
    
    override func didMove(to view: SKView)
    {
        let floorcover = SKShapeNode(rect: CGRect(x: 0, y: 0, width: self.size.width, height: 30));//Purely for visual effect
        let roofcover = SKShapeNode(rect: CGRect(x: 0, y: self.size.height-35, width: self.size.width, height: 35));
        floorcover.fillColor = SKColor.blue;
        roofcover.fillColor = SKColor.blue;
        floorcover.strokeColor = SKColor.blue;
        roofcover.strokeColor = SKColor.blue;
        floorcover.zPosition = 3;
        roofcover.zPosition = 3;
        addChild(floorcover);
        addChild(roofcover);
        
        pointLabel.text = "Points: 0";//these setup the display for the points and health labels VVVVVVV
        healthLabel.text = "Health: 3";
        pointLabel.fontName = "Courier";
        healthLabel.fontName = "Courier";
        pointLabel.fontColor = SKColor.yellow;
        pointLabel.position = CGPoint(x: size.width-100, y: size.height-50);
        healthLabel.fontColor = SKColor.red;
        healthLabel.position = CGPoint(x: size.width-100, y: size.height-90);
        pointLabel.zPosition = 3;
        healthLabel.zPosition = 3;
        
        let floor = SKShapeNode(rect: CGRect(x: 0, y: 0, width: self.size.width, height: 30));//Sets up the roof and the floor as well as the physics bodies
        let roof = SKShapeNode(rect: CGRect(x: 0, y: self.size.height-30, width: self.size.width, height: 30));
        floor.fillColor = SKColor.blue;
        roof.fillColor = SKColor.blue;
        floor.physicsBody = SKPhysicsBody(edgeLoopFrom: floor.frame);
        roof.physicsBody = SKPhysicsBody(edgeLoopFrom: roof.frame);
        floor.physicsBody?.isDynamic = false;
        roof.physicsBody?.isDynamic = false;
        floor.physicsBody?.affectedByGravity = false;
        roof.physicsBody?.affectedByGravity = false;
        addChild(floor);
        addChild(roof);
        
        let instructions = SKAction.run {
            self.announcementLabel = SKLabelNode(text: "Avoid obstacles and collect 15 points to win");
            self.announcementLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2);
            self.announcementLabel.fontColor = SKColor.black;
            self.addChild(self.announcementLabel);
        }
        
        let spawnPlayer = SKAction.run {
            self.control = true;
            self.announcementLabel.text = "";
            self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -3.5);
            self.player.position = CGPoint(x: self.frame.size.width/2-200, y: self.frame.size.height/2);
            self.player.addChild(self.playerSprite);
            self.playerParticle.targetNode = self;
            self.playerSprite.size = CGSize(width: 96, height: 80);
            self.playerParticle.position = CGPoint(x: 20, y: -35);
            self.player.addChild(self.playerParticle);
            self.playerParticle.zPosition = 1;
            self.player.physicsBody = self.playerPhysicsBody;
            self.playerPhysicsBody.affectedByGravity = true;
            self.addChild(self.player);
            self.addChild(self.pointLabel);
            self.addChild(self.healthLabel);
            self.EventGenerator();
        }
        backgroundshift();
        run(SKAction.sequence([instructions, SKAction.wait(forDuration: 4.5), spawnPlayer]));
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(control){
            if(player.physicsBody!.velocity.dy < 30 && player.physicsBody!.velocity.dy > -10)
            {
                player.physicsBody?.velocity.dy = 60;
                player.physicsBody?.velocity.dy *= -1;
                playerSprite.size.height *= -1;
                playerParticle.position.y *= -1;
                playerParticle.emissionAngle *= -1;
                playerParticle.yAcceleration *= -1;
                self.physicsWorld.gravity.dy *= -1;
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(playerSprite.intersects(currentPoint))
        {
            points += 1;
            currentPoint.position.x = CGFloat(-frame.size.width);
            pointLabel.text = "Points: " + String(points);
            if(points == 15){
                GameOver(result: "win");
            }
        }
        if(playerSprite.intersects(currentObstacle))
        {
            health -= 1;
            currentObstacle.position.x = CGFloat(-frame.size.width);
            healthLabel.text = "Health: " + String(health);
            if(health == 0){
                GameOver(result: "");
            }
        }
    }
    
    func EventGenerator()//Generates obstacles and points
    {
        let generateTreasure = SKAction.run {
            self.TreasureEvent(event: Int.random(in: 0...2));
        }
        let generateObstacle = SKAction.run {
            self.ObstacleEvent(event: Int.random(in: 0...5));
        }
        let eventGroup = SKAction.sequence([generateObstacle, SKAction.wait(forDuration: self.worldSpeed*0.5), generateTreasure]);
        run(SKAction.repeatForever(SKAction.sequence([eventGroup, SKAction.wait(forDuration: self.worldSpeed*0.6)])));
    }
    
    func ObstacleEvent(event: Int)
    {
        switch event {//Randomly chooses an enemy and where it spawns
        case 0:
            currentObstacle = SKSpriteNode(imageNamed: "obstacle1");
            print("o1");
            currentObstacle.size = CGSize(width: 100, height: -100);
            currentObstacle.position.y = CGFloat(frame.size.height - 30);
            break;
        case 1:
            currentObstacle = SKSpriteNode(imageNamed: "obstacle2");
            print("o2");
            currentObstacle.size = CGSize(width: 120, height: -100);
            currentObstacle.position.y = CGFloat(frame.size.height - 20);
            break;
        case 2:
            currentObstacle = SKSpriteNode(imageNamed: "obstacle3");
            print("o3");
            currentObstacle.size = CGSize(width: -140, height: -100);
            currentObstacle.position.y = CGFloat(frame.size.height - 40);
            break;
        case 3:
            currentObstacle = SKSpriteNode(imageNamed: "obstacle1");
            print("o1");
            currentObstacle.size = CGSize(width: 100, height: 100);
            currentObstacle.position.y = CGFloat(30);
            break;
        case 4:
            currentObstacle = SKSpriteNode(imageNamed: "obstacle2");
            print("o2");
            currentObstacle.size = CGSize(width: 120, height: 100);
            currentObstacle.position.y = CGFloat(30);
            break;
        case 5:
            currentObstacle = SKSpriteNode(imageNamed: "obstacle3");
            currentObstacle.size = CGSize(width: -140, height: 100);
            currentObstacle.position.y = CGFloat(40);
            print("o3");
            break;
        default:
            print("error");
        }
        
        let move = SKAction.run {//Moves it across the screen
            self.addChild(self.currentObstacle);
            self.currentObstacle.position.x = self.frame.size.width;
            self.currentObstacle.zPosition = 1;
            self.currentObstacle.run(SKAction.moveBy(x: (-self.size.width - self.size.width/2),y: 0, duration: (self.worldSpeed+self.worldSpeed/2)));
        }
        let reset = SKAction.run{
            self.currentObstacle = SKSpriteNode.init();
            self.currentObstacle.removeFromParent();
        }
         run(SKAction.sequence([move, SKAction.wait(forDuration: worldSpeed), reset]));
    }
    
    func TreasureEvent(event: Int)
    {
        currentPoint = SKSpriteNode(imageNamed: "treasure");
        currentPoint.size = CGSize(width: 50, height: 50);
        addChild(currentPoint);
        let move = SKAction.run {
            self.currentPoint.position.x = self.frame.size.width;
            self.currentPoint.zPosition = 1;
            self.currentPoint.run(SKAction.moveBy(x: (-self.size.width - self.size.width/2),y: 0, duration: (self.worldSpeed+self.worldSpeed/2)));
        }
        let reset = SKAction.run{
            self.currentPoint = SKSpriteNode.init();
            self.currentPoint.removeFromParent();
        }
        switch event {
        case 0:
             print("p1");
             currentPoint.position.y = CGFloat(frame.size.height - 50);
             break;
        case 1:
            currentPoint.position.y = CGFloat(50);
            print("p2");
            break;
        case 2:
            currentPoint.position.y = CGFloat(frame.size.height / 2);
            print("p3");
        default:
            print("error");
        }
        run(SKAction.sequence([move, SKAction.wait(forDuration: worldSpeed), reset]));
    }
    
    func backgroundshift()
    {
        var backgrounds: [SKSpriteNode] = [SKSpriteNode(imageNamed: "testback"), SKSpriteNode(imageNamed: "testback"), SKSpriteNode(imageNamed: "testback")];
        for i in 0...2{
            backgrounds[i].size = CGSize(width: frame.size.width, height: frame.size.height);
            let position: CGFloat = (CGFloat(i-1))*frame.size.width + frame.size.width/2;
            backgrounds[i].position = CGPoint(x: position, y: frame.size.height/2);
            backgrounds[i].zPosition = -1;
            addChild(backgrounds[i]);
        }
        let resetPosition = SKAction.run {
            for i in 0...2{
                let position: CGFloat = (CGFloat(i-1))*self.frame.size.width + self.frame.size.width/2;
                backgrounds[i].position = CGPoint(x: position, y: self.frame.size.height/2);
            }
        }
        let move = SKAction.run {
            for i in 0...2{
                backgrounds[i].run(SKAction.moveBy(x: -self.size.width,y: 0, duration: self.worldSpeed));
            }
        }
        let backrotation = SKAction.sequence([move, SKAction.wait(forDuration: self.worldSpeed), resetPosition]);
        run(SKAction.repeatForever(backrotation));
    }
    
    func GameOver(result: String)
    {
        control = false;
        playerParticle.removeFromParent();
        if(result == "win")
        {
            announcementLabel.fontColor = SKColor.green;
            announcementLabel.text = "You win!";
        }
        else
        {
            announcementLabel.fontColor = SKColor.red;
            announcementLabel.text = "Game Over";
        }
        announcementLabel.fontName = "Courier";
        playerSprite.position.x = -frame.width;
        let returnToStart = SKAction.run{
            let newScene = Start(size: self.size);
            self.view?.presentScene(newScene);
        }
        run(SKAction.sequence([SKAction.wait(forDuration: 5), returnToStart]));
    }
}
