
function $(selector) {
    var doms = document.querySelectorAll(selector)
    if (doms.length === 1) return doms[0]
    return doms
}

function extend(constructor, prototype) {
    var Super = this
    function Sub() {constructor.apply(this, arguments)}
    function F() {}
    F.prototype = Super.prototype
    Sub.prototype = new F()
    for (var prop in prototype) {
        Sub.prototype[prop] = prototype[prop]
    }
    Sub.prototype.constructor = constructor.name
    Sub.name = constructor.name
    Sub.extend = extend
    return Sub
}

module.exports = {
    extend: extend,
    $: $
}