
import Foundation
import SpriteKit

class Start: SKScene{
    override func didMove(to view: SKView) {
        backgroundshift();
        let play = SKSpriteNode(imageNamed: "play");
        play.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2-100);
        addChild(play);
        
        let title = SKLabelNode(text: "Too Much Water: The Game");
        title.fontColor = SKColor.black;
        title.fontName = "Courier";
        title.fontSize = 50;
        title.horizontalAlignmentMode = .center;
        title.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2+100);
        addChild(title);
        
        let floor = SKShapeNode(rect: CGRect(x: 0, y: 0, width: self.size.width, height: 30));
        let roof = SKShapeNode(rect: CGRect(x: 0, y: self.size.height-30, width: self.size.width, height: 30));
        floor.fillColor = SKColor.blue;
        roof.fillColor = SKColor.blue;
        addChild(floor);
        addChild(roof);
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!.location(in: view);
        if(touch.x > frame.size.width/2 - 150 && touch.x < frame.size.width/2 + 150)
        {
            print(touch.y);
            if(touch.y < frame.size.height/2 + 200 && touch.y > frame.size.height/2){
                print("ready");
                let newScene = GameScene(size: self.size);
                self.view?.presentScene(newScene);
            }
        }
    }
    
    func backgroundshift()
    {
        var backgrounds: [SKSpriteNode] = [SKSpriteNode(imageNamed: "testback"), SKSpriteNode(imageNamed: "testback"), SKSpriteNode(imageNamed: "testback")];
        for i in 0...2
        {
            backgrounds[i].size = CGSize(width: frame.size.width, height: frame.size.height);
            let position: CGFloat = (CGFloat(i-1))*frame.size.width + frame.size.width/2;
            backgrounds[i].position = CGPoint(x: position, y: frame.size.height/2);
            backgrounds[i].zPosition = -1;
            addChild(backgrounds[i]);
        }
        let resetPosition = SKAction.run
        {
            for i in 0...2
            {
                let position: CGFloat = (CGFloat(i-1))*self.frame.size.width + self.frame.size.width/2;
                backgrounds[i].position = CGPoint(x: position, y: self.frame.size.height/2);
            }
        }
        let move = SKAction.run
        {
            for i in 0...2
            {
                backgrounds[i].run(SKAction.moveBy(x: -self.size.width,y: 0, duration: 6));
            }
        }
        let backrotation = SKAction.sequence([move, SKAction.wait(forDuration: 6), resetPosition]);
        run(SKAction.repeatForever(backrotation));
    }
}
