import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["qr_svg"];

  connect() {
    // console.log("Hello, Stimulus!", this.element);
  }

  print_qr(event) {
    const svg = this.qr_svgTarget
    const win = window.open('');
    win.document.write(svg.firstElementChild.outerHTML);
    win.focus();
    win.print()
  }
}

