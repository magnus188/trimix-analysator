"""Draw a dimension schematic from recorded envelopes; not a part drawing."""
from pathlib import Path
from PIL import Image,ImageDraw,ImageFont
BASE=Path(__file__).resolve().parents[1]
def build():
    im=Image.new('RGB',(1800,1160),'#f7fafb');d=ImageDraw.Draw(im)
    def font(s,bold=False):return ImageFont.truetype('/System/Library/Fonts/Supplemental/Arial'+(' Bold' if bold else '')+'.ttf',s)
    def text(x,y,s,size=26,color='#25364b',bold=False):d.multiline_text((x,y),s,font=font(size,bold),fill=color,spacing=6)
    def arrow(a,b,c):
        d.line([a,b],fill=c,width=3)
        if a[1]==b[1]:
            for x,sign in [(a[0],1),(b[0],-1)]:d.line([(x+sign*12,a[1]-7),(x,a[1]),(x+sign*12,a[1]+7)],fill=c,width=3)
        else:
            for y,sign in [(a[1],1),(b[1],-1)]:d.line([(a[0]-7,y+sign*12),(a[0],y),(a[0]+7,y+sign*12)],fill=c,width=3)
    text(75,45,'Measure both sensors from the same sealing shoulder',43,bold=True)
    scale=12;x=460
    for title,L,D,y,c in [('AO2 reference',31.75,29.3,350,'#2f7483'),('JJ comparative envelope',33.75,27.3,815,'#897135')]:
        text(75,y-220,title,32,c,True)
        end=x+L*scale;h=D*scale/2
        d.rectangle([x,y-h,end,y+h],fill='#e1ebed' if L<33 else '#eee9db',outline=c,width=3)
        d.rectangle([x-6.5*scale,y-8*scale,x,y+8*scale],outline=c,width=3)
        d.rectangle([end,y-5*scale,end+6.5*scale,y+5*scale],outline='#89949c',width=2)
        d.line([(x,y-h-45),(x,y+h+35)],fill='#25364b',width=3)
        arrow((x,y+h+25),(end,y+h+25),c)
        text(x+30,y+h+38,f'{L:.2f} mm body length in current model',24,c)
        arrow((end+400,y-h),(end+400,y+h),c)
        text(end+420,y-17,f'Diameter {D:.1f} mm',25,c)
        text(x+35,y-h-42,'Sealing shoulder: record its exact location',24)
        text(95,y-22,'Nose / thread\nmeasure length',24)
        text(end+10,y-145,'Actual mated plug\nand cable bend needed',22,'#526475')
    text(75,1080,'Schematic only. JJ: owner reports diameter -2 mm and length +2 mm.\nUnchanged nose length/shoulder are assumptions; plug boxes are unmeasured allowances.',25,'#526475')
    out=BASE/'views';out.mkdir(exist_ok=True);im.save(out/'oxygen-measurement-datums.png')
if __name__=='__main__':build()
