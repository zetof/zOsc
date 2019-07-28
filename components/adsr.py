from kivy.uix.gridlayout import GridLayout
from kivy.properties import StringProperty, NumericProperty


class Adsr(GridLayout):
    osc_group = StringProperty()
    widget_group = NumericProperty()