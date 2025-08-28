import NestedForm from "stimulus-rails-nested-form";

export default class extends NestedForm {
  static values = {
    // you already use wrapperSelectorValue from the base class
    newRecordToken: { type: String, default: "NEW_RECORD" },
  };

  connect() {
    super.connect();
    // console.log("nested-form connected", this.newRecordTokenValue);
  }

  add(event) {
    event.preventDefault();

    // Only replace the token configured for THIS instance
    const token = this.newRecordTokenValue || "NEW_RECORD";
    const html = this.templateTarget.innerHTML;

    // unique id per insertion
    const uid = `${Date.now()}${Math.floor(Math.random() * 1e6)}`;

    // Replace ONLY this token (not every "NEW_RECORD" everywhere)
    const fragment = html.replaceAll(token, uid);

    this.targetTarget.insertAdjacentHTML("beforeend", fragment);
  }
}
