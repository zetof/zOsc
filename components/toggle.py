from kivy.app import App
from kivy.uix.gridlayout import GridLayout
from kivy.properties import NumericProperty
from kivy.properties import StringProperty


class Toggle(GridLayout):
    widget_name = StringProperty()
    widget_value = NumericProperty()
    osc_group = StringProperty()

    def on_touch_down(self, touch):
        app = App.get_running_app()
        if self.collide_point(*touch.pos):
            app.root.current_used_widget = self.widget_name
            if self.widget_value == 0:
                self.widget_value = 1
            else:
                self.widget_value = 0
            app.root.osc.send(self.osc_group, self.widget_name, self.widget_value)
        return super(Toggle, self).on_touch_down(touch)

    def on_touch_up(self, touch):
        app = App.get_running_app()
        app.root.current_used_widget = None
        return super(Toggle, self).on_touch_up(touch)