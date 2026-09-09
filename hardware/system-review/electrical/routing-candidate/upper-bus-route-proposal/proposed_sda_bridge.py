"""Reviewable optional SDA lift; defining this module performs no board mutation.

Call apply(c) only after the PCB owner approves this specific original-segment
replacement. The parent owns integration; this helper only receives an isolated
candidate builder. Both native source coordinates and net/layer are asserted.
"""
SDA_UUID='03fb83e2-af05-49db-9428-77bb39e6c5ac'
START=(13.946,82.3733);END=(21.1164,75.2029)
A=(16.8,79.5193);Z=(17.8,78.5193)
def apply(c):
 t=next(t for t in c.b.GetTracks()if t.m_Uuid.AsString()==SDA_UUID)
 assert t.GetNetname()=='I2C_SDA' and t.GetLayer()==c.p.In2_Cu
 assert c.xy(t.GetStart())==list(START) and c.xy(t.GetEnd())==list(END)
 assert c.p.ToMM(t.GetWidth())==.15
 c.remove([SDA_UUID])
 c.track('I2C_SDA',[START,A],c.p.In2_Cu)
 c.via('I2C_SDA',A);c.via('I2C_SDA',Z)
 c.track('I2C_SDA',[A,Z],c.p.F_Cu)
 c.track('I2C_SDA',[Z,END],c.p.In2_Cu)
