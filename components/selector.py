from kivy.app import App
from kivy.uix.gridlayout import GridLayout
from kivy.properties import StringProperty, NumericProperty


class Selector(GridLayout):
    widget_name = StringProperty()
    widget_value = NumericProperty()
    widget_group = NumericProperty()
    widget_choices = NumericProperty()
    osc_group = StringProperty()

    def on_touch_down(self, touch):
        app = App.get_running_app()
        if self.collide_point(*touch.pos):
            app.root.set_used_widget(self.widget_name, self.widget_group)
            value = self.widget_value + 1
            if value == self.widget_choices:
                self.widget_value = 0
            else:
                self.widget_value = value
            app.root.osc.send(self.osc_group, self.widget_name, self.widget_group,  self.widget_value)
        return super(Selector, self).on_touch_down(touch)

    def on_touch_up(self, touch):
        app = App.get_running_app()
        app.root.release_widget()
        return super(Selector, self).on_touch_up(touch)
