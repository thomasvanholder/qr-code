// Load all the controllers within this directory and all subdirectories.
// Controller files must be named *_controller.js.

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"
import StimulusReflex from 'stimulus_reflex'
import consumer from '../channels/consumer'
import controller from './application_controller'
import { Tabs, Alert } from "tailwindcss-stimulus-components";

const application = Application.start()
const context = require.context("controllers", true, /_controller\.js$/)
application.load(definitionsFromContext(context))

application.register("tabs", Tabs);
application.register("alert", Alert);

StimulusReflex.initialize(application, { consumer, controller, debug: false })
