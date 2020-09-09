(function dartProgram(){function copyProperties(a,b){var t=Object.keys(a)
for(var s=0;s<t.length;s++){var r=t[s]
b[r]=a[r]}}var z=function(){var t=function(){}
t.prototype={p:{}}
var s=new t()
if(!(s.__proto__&&s.__proto__.p===t.prototype.p))return false
try{if(typeof navigator!="undefined"&&typeof navigator.userAgent=="string"&&navigator.userAgent.indexOf("Chrome/")>=0)return true
if(typeof version=="function"&&version.length==0){var r=version()
if(/^\d+\.\d+\.\d+\.\d+$/.test(r))return true}}catch(q){}return false}()
function setFunctionNamesIfNecessary(a){function t(){};if(typeof t.name=="string")return
for(var t=0;t<a.length;t++){var s=a[t]
var r=Object.keys(s)
for(var q=0;q<r.length;q++){var p=r[q]
var o=s[p]
if(typeof o=='function')o.name=p}}}function inherit(a,b){a.prototype.constructor=a
a.prototype["$i"+a.name]=a
if(b!=null){if(z){a.prototype.__proto__=b.prototype
return}var t=Object.create(b.prototype)
copyProperties(a.prototype,t)
a.prototype=t}}function inheritMany(a,b){for(var t=0;t<b.length;t++)inherit(b[t],a)}function mixin(a,b){copyProperties(b.prototype,a.prototype)
a.prototype.constructor=a}function lazy(a,b,c,d){var t=a
a[b]=t
a[c]=function(){a[c]=function(){H.cu(b)}
var s
var r=d
try{if(a[b]===t){s=a[b]=r
s=a[b]=d()}else s=a[b]}finally{if(s===r)a[b]=null
a[c]=function(){return this[b]}}return s}}function makeConstList(a){a.immutable$list=Array
a.fixed$length=Array
return a}function convertToFastObject(a){function t(){}t.prototype=a
new t()
return a}function convertAllToFastObject(a){for(var t=0;t<a.length;++t)convertToFastObject(a[t])}var y=0
function tearOffGetter(a,b,c,d,e){return e?new Function("funcs","applyTrampolineIndex","reflectionInfo","name","H","c","return function tearOff_"+d+y+++"(receiver) {"+"if (c === null) c = "+"H.aF"+"("+"this, funcs, applyTrampolineIndex, reflectionInfo, false, true, name);"+"return new c(this, funcs[0], receiver, name);"+"}")(a,b,c,d,H,null):new Function("funcs","applyTrampolineIndex","reflectionInfo","name","H","c","return function tearOff_"+d+y+++"() {"+"if (c === null) c = "+"H.aF"+"("+"this, funcs, applyTrampolineIndex, reflectionInfo, false, false, name);"+"return new c(this, funcs[0], null, name);"+"}")(a,b,c,d,H,null)}function tearOff(a,b,c,d,e,f){var t=null
return d?function(){if(t===null)t=H.aF(this,a,b,c,true,false,e).prototype
return t}:tearOffGetter(a,b,c,e,f)}var x=0
function installTearOff(a,b,c,d,e,f,g,h,i,j){var t=[]
for(var s=0;s<h.length;s++){var r=h[s]
if(typeof r=='string')r=a[r]
r.$callName=g[s]
t.push(r)}var r=t[0]
r.$R=e
r.$D=f
var q=i
if(typeof q=="number")q+=x
var p=h[0]
r.$stubName=p
var o=tearOff(t,j||0,q,c,p,d)
a[b]=o
if(c)r.$tearOff=o}function installStaticTearOff(a,b,c,d,e,f,g,h){return installTearOff(a,b,true,false,c,d,e,f,g,h)}function installInstanceTearOff(a,b,c,d,e,f,g,h,i){return installTearOff(a,b,false,c,d,e,f,g,h,i)}function setOrUpdateInterceptorsByTag(a){var t=v.interceptorsByTag
if(!t){v.interceptorsByTag=a
return}copyProperties(a,t)}function setOrUpdateLeafTags(a){var t=v.leafTags
if(!t){v.leafTags=a
return}copyProperties(a,t)}function updateTypes(a){var t=v.types
var s=t.length
t.push.apply(t,a)
return s}function updateHolder(a,b){copyProperties(b,a)
return a}var hunkHelpers=function(){var t=function(a,b,c,d,e){return function(f,g,h,i){return installInstanceTearOff(f,g,a,b,c,d,[h],i,e)}},s=function(a,b,c,d){return function(e,f,g,h){return installStaticTearOff(e,f,a,b,c,[g],h,d)}}
return{inherit:inherit,inheritMany:inheritMany,mixin:mixin,installStaticTearOff:installStaticTearOff,installInstanceTearOff:installInstanceTearOff,_instance_0u:t(0,0,null,["$0"],0),_instance_1u:t(0,1,null,["$1"],0),_instance_2u:t(0,2,null,["$2"],0),_instance_0i:t(1,0,null,["$0"],0),_instance_1i:t(1,1,null,["$1"],0),_instance_2i:t(1,2,null,["$2"],0),_static_0:s(0,null,["$0"],0),_static_1:s(1,null,["$1"],0),_static_2:s(2,null,["$2"],0),makeConstList:makeConstList,lazy:lazy,updateHolder:updateHolder,convertToFastObject:convertToFastObject,setFunctionNamesIfNecessary:setFunctionNamesIfNecessary,updateTypes:updateTypes,setOrUpdateInterceptorsByTag:setOrUpdateInterceptorsByTag,setOrUpdateLeafTags:setOrUpdateLeafTags}}()
function initializeDeferredHunk(a){x=v.types.length
a(hunkHelpers,v,w,$)}function getGlobalFromName(a){for(var t=0;t<w.length;t++){if(w[t]==C)continue
if(w[t][a])return w[t][a]}}var C={},H={ax:function ax(){},
bp:function(a){var t,s=H.bo(a)
if(s!=null)return s
t="minified:"+a
return t},
d:function(a){var t
if(typeof a=="string")return a
if(typeof a=="number"){if(a!==0)return""+a}else if(!0===a)return"true"
else if(!1===a)return"false"
else if(a==null)return"null"
t=J.Z(a)
if(typeof t!="string")throw H.c(H.bd(a))
return t},
ae:function(a){return H.bE(a)},
bE:function(a){var t,s,r
if(a instanceof P.h)return H.j(H.J(a),null)
if(J.ap(a)===C.n||u.o.b(a)){t=C.c(a)
if(H.aS(t))return t
s=a.constructor
if(typeof s=="function"){r=s.name
if(typeof r=="string"&&H.aS(r))return r}}return H.j(H.J(a),null)},
aS:function(a){var t=a!=="Object"&&a!==""
return t},
cm:function(a){throw H.c(H.bd(a))},
aI:function(a,b){if(a==null)J.br(a)
throw H.c(H.ci(a,b))},
ci:function(a,b){var t,s,r,q="index"
if(!H.bb(b))return new P.t(!0,b,q,null)
t=J.bf(a)
s=t.gj(a)
if(!(b<0)){if(typeof s!=="number")return H.cm(s)
r=b>=s}else r=!0
if(r){t=s==null?t.gj(a):s
return new P.a9(t,!0,b,q,"Index out of range")}return new P.af(!0,b,q,"Value not in range")},
bd:function(a){return new P.t(!0,a,null,null)},
c:function(a){var t,s
if(a==null)a=new P.ad()
t=new Error()
t.dartException=a
s=H.cv
if("defineProperty" in Object){Object.defineProperty(t,"message",{get:s})
t.name=""}else t.toString=s
return t},
cv:function(){return J.Z(this.dartException)},
bn:function(a){throw H.c(a)},
ct:function(a){throw H.c(new P.a3(a))},
bB:function(a,b,c,d,e,f,g){var t,s,r,q,p,o,n,m=b[0],l=m.$callName,k=e?Object.create(new H.ai().constructor.prototype):Object.create(new H.M(null,null,null,"").constructor.prototype)
k.$initialize=k.constructor
if(e)t=function static_tear_off(){this.$initialize()}
else{s=$.m
if(typeof s!=="number")return s.i()
$.m=s+1
s=new Function("a,b,c,d"+s,"this.$initialize(a,b,c,d"+s+")")
t=s}k.constructor=t
t.prototype=k
if(!e){r=H.aP(a,m,f)
r.$reflectionInfo=d}else{k.$static_name=g
r=m}k.$S=H.bx(d,e,f)
k[l]=r
for(q=r,p=1;p<b.length;++p){o=b[p]
n=o.$callName
if(n!=null){o=e?o:H.aP(a,o,f)
k[n]=o}if(p===c){o.$reflectionInfo=d
q=o}}k.$C=q
k.$R=m.$R
k.$D=m.$D
return t},
bx:function(a,b,c){var t
if(typeof a=="number")return function(d,e){return function(){return d(e)}}(H.bh,a)
if(typeof a=="string"){if(b)throw H.c("Cannot compute signature for static tearoff.")
t=c?H.bv:H.bu
return function(d,e){return function(){return e(this,d)}}(a,t)}throw H.c("Error in functionType of tearoff")},
by:function(a,b,c,d){var t=H.aO
switch(b?-1:a){case 0:return function(e,f){return function(){return f(this)[e]()}}(c,t)
case 1:return function(e,f){return function(g){return f(this)[e](g)}}(c,t)
case 2:return function(e,f){return function(g,h){return f(this)[e](g,h)}}(c,t)
case 3:return function(e,f){return function(g,h,i){return f(this)[e](g,h,i)}}(c,t)
case 4:return function(e,f){return function(g,h,i,j){return f(this)[e](g,h,i,j)}}(c,t)
case 5:return function(e,f){return function(g,h,i,j,k){return f(this)[e](g,h,i,j,k)}}(c,t)
default:return function(e,f){return function(){return e.apply(f(this),arguments)}}(d,t)}},
aP:function(a,b,c){var t,s,r,q,p,o,n
if(c)return H.bA(a,b)
t=b.$stubName
s=b.length
r=a[t]
q=b==null?r==null:b===r
p=!q||s>=27
if(p)return H.by(s,!q,t,b)
if(s===0){q=$.m
if(typeof q!=="number")return q.i()
$.m=q+1
o="self"+q
return new Function("return function(){var "+o+" = this."+H.d(H.aw())+";return "+o+"."+H.d(t)+"();}")()}n="abcdefghijklmnopqrstuvwxyz".split("").splice(0,s).join(",")
q=$.m
if(typeof q!=="number")return q.i()
$.m=q+1
n+=q
return new Function("return function("+n+"){return this."+H.d(H.aw())+"."+H.d(t)+"("+n+");}")()},
bz:function(a,b,c,d){var t=H.aO,s=H.bw
switch(b?-1:a){case 0:throw H.c(new H.ag("Intercepted function with no arguments."))
case 1:return function(e,f,g){return function(){return f(this)[e](g(this))}}(c,t,s)
case 2:return function(e,f,g){return function(h){return f(this)[e](g(this),h)}}(c,t,s)
case 3:return function(e,f,g){return function(h,i){return f(this)[e](g(this),h,i)}}(c,t,s)
case 4:return function(e,f,g){return function(h,i,j){return f(this)[e](g(this),h,i,j)}}(c,t,s)
case 5:return function(e,f,g){return function(h,i,j,k){return f(this)[e](g(this),h,i,j,k)}}(c,t,s)
case 6:return function(e,f,g){return function(h,i,j,k,l){return f(this)[e](g(this),h,i,j,k,l)}}(c,t,s)
default:return function(e,f,g,h){return function(){h=[g(this)]
Array.prototype.push.apply(h,arguments)
return e.apply(f(this),h)}}(d,t,s)}},
bA:function(a,b){var t,s,r,q,p,o,n=H.aw(),m=$.aM
if(m==null)m=$.aM=H.aL("receiver")
t=b.$stubName
s=b.length
r=a[t]
q=b==null?r==null:b===r
p=!q||s>=28
if(p)return H.bz(s,!q,t,b)
if(s===1){q="return function(){return this."+H.d(n)+"."+H.d(t)+"(this."+m+");"
p=$.m
if(typeof p!=="number")return p.i()
$.m=p+1
return new Function(q+p+"}")()}o="abcdefghijklmnopqrstuvwxyz".split("").splice(0,s-1).join(",")
q="return function("+o+"){return this."+H.d(n)+"."+H.d(t)+"(this."+m+", "+o+");"
p=$.m
if(typeof p!=="number")return p.i()
$.m=p+1
return new Function(q+p+"}")()},
aF:function(a,b,c,d,e,f,g){return H.bB(a,b,c,d,!!e,!!f,g)},
bu:function(a,b){return H.X(v.typeUniverse,H.J(a.a),b)},
bv:function(a,b){return H.X(v.typeUniverse,H.J(a.c),b)},
aO:function(a){return a.a},
bw:function(a){return a.c},
aw:function(){var t=$.aN
return t==null?$.aN=H.aL("self"):t},
aL:function(a){var t,s,r,q=new H.M("self","target","receiver","name"),p=Object.getOwnPropertyNames(q)
p.fixed$length=Array
t=p
for(p=t.length,s=0;s<p;++s){r=t[s]
if(q[r]===a)return r}throw H.c(new P.t(!1,null,null,"Field name "+a+" not found."))},
cu:function(a){throw H.c(new P.a4(a))},
cl:function(a){return v.getIsolateTag(a)},
cr:function(a){var t,s,r,q,p,o=H.b6($.bg.$1(a)),n=$.ao[o]
if(n!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:n,enumerable:false,writable:true,configurable:true})
return n.i}t=$.at[o]
if(t!=null)return t
s=v.interceptorsByTag[o]
if(s==null){r=H.bY($.bc.$2(a,o))
if(r!=null){n=$.ao[r]
if(n!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:n,enumerable:false,writable:true,configurable:true})
return n.i}t=$.at[r]
if(t!=null)return t
s=v.interceptorsByTag[r]
o=r}}if(s==null)return null
t=s.prototype
q=o[0]
if(q==="!"){n=H.av(t)
$.ao[o]=n
Object.defineProperty(a,v.dispatchPropertyName,{value:n,enumerable:false,writable:true,configurable:true})
return n.i}if(q==="~"){$.at[o]=t
return t}if(q==="-"){p=H.av(t)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:p,enumerable:false,writable:true,configurable:true})
return p.i}if(q==="+")return H.bk(a,t)
if(q==="*")throw H.c(P.aV(o))
if(v.leafTags[o]===true){p=H.av(t)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:p,enumerable:false,writable:true,configurable:true})
return p.i}else return H.bk(a,t)},
bk:function(a,b){var t=Object.getPrototypeOf(a)
Object.defineProperty(t,v.dispatchPropertyName,{value:J.aJ(b,t,null,null),enumerable:false,writable:true,configurable:true})
return b},
av:function(a){return J.aJ(a,!1,null,!!a.$icy)},
cs:function(a,b,c){var t=b.prototype
if(v.leafTags[a]===true)return H.av(t)
else return J.aJ(t,c,null,null)},
co:function(){if(!0===$.aH)return
$.aH=!0
H.cp()},
cp:function(){var t,s,r,q,p,o,n,m
$.ao=Object.create(null)
$.at=Object.create(null)
H.cn()
t=v.interceptorsByTag
s=Object.getOwnPropertyNames(t)
if(typeof window!="undefined"){window
r=function(){}
for(q=0;q<s.length;++q){p=s[q]
o=$.bl.$1(p)
if(o!=null){n=H.cs(p,t[p],o)
if(n!=null){Object.defineProperty(o,v.dispatchPropertyName,{value:n,enumerable:false,writable:true,configurable:true})
r.prototype=o}}}}for(q=0;q<s.length;++q){p=s[q]
if(/^[A-Za-z_]/.test(p)){m=t[p]
t["!"+p]=m
t["~"+p]=m
t["-"+p]=m
t["+"+p]=m
t["*"+p]=m}}},
cn:function(){var t,s,r,q,p,o,n=C.h()
n=H.A(C.i,H.A(C.j,H.A(C.d,H.A(C.d,H.A(C.k,H.A(C.l,H.A(C.m(C.c),n)))))))
if(typeof dartNativeDispatchHooksTransformer!="undefined"){t=dartNativeDispatchHooksTransformer
if(typeof t=="function")t=[t]
if(t.constructor==Array)for(s=0;s<t.length;++s){r=t[s]
if(typeof r=="function")n=r(n)||n}}q=n.getTag
p=n.getUnknownTag
o=n.prototypeForTag
$.bg=new H.aq(q)
$.bc=new H.ar(p)
$.bl=new H.as(o)},
A:function(a,b){return a(b)||b},
x:function x(){},
ak:function ak(){},
ai:function ai(){},
M:function M(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
ag:function ag(a){this.a=a},
aq:function aq(a){this.a=a},
ar:function ar(a){this.a=a},
as:function as(a){this.a=a},
bG:function(a,b){var t=b.c
return t==null?b.c=H.aB(a,b.z,!0):t},
aT:function(a,b){var t=b.c
return t==null?b.c=H.E(a,"aQ",[b.z]):t},
aU:function(a){var t=a.y
if(t===6||t===7||t===8)return H.aU(a.z)
return t===11||t===12},
bF:function(a){return a.cy},
be:function(a){return H.aC(v.typeUniverse,a,!1)},
r:function(a,b,c,a0){var t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=b.y
switch(d){case 5:case 1:case 2:case 3:case 4:return b
case 6:t=b.z
s=H.r(a,t,c,a0)
if(s===t)return b
return H.b2(a,s,!0)
case 7:t=b.z
s=H.r(a,t,c,a0)
if(s===t)return b
return H.aB(a,s,!0)
case 8:t=b.z
s=H.r(a,t,c,a0)
if(s===t)return b
return H.b1(a,s,!0)
case 9:r=b.Q
q=H.H(a,r,c,a0)
if(q===r)return b
return H.E(a,b.z,q)
case 10:p=b.z
o=H.r(a,p,c,a0)
n=b.Q
m=H.H(a,n,c,a0)
if(o===p&&m===n)return b
return H.az(a,o,m)
case 11:l=b.z
k=H.r(a,l,c,a0)
j=b.Q
i=H.ce(a,j,c,a0)
if(k===l&&i===j)return b
return H.b0(a,k,i)
case 12:h=b.Q
a0+=h.length
g=H.H(a,h,c,a0)
p=b.z
o=H.r(a,p,c,a0)
if(g===h&&o===p)return b
return H.aA(a,o,g,!0)
case 13:f=b.z
if(f<a0)return b
e=c[f-a0]
if(e==null)return b
return e
default:throw H.c(P.a2("Attempted to substitute unexpected RTI kind "+d))}},
H:function(a,b,c,d){var t,s,r,q,p=b.length,o=[]
for(t=!1,s=0;s<p;++s){r=b[s]
q=H.r(a,r,c,d)
if(q!==r)t=!0
o.push(q)}return t?o:b},
cf:function(a,b,c,d){var t,s,r,q,p,o,n=b.length,m=[]
for(t=!1,s=0;s<n;s+=3){r=b[s]
q=b[s+1]
p=b[s+2]
o=H.r(a,p,c,d)
if(o!==p)t=!0
m.push(r)
m.push(q)
m.push(o)}return t?m:b},
ce:function(a,b,c,d){var t,s=b.a,r=H.H(a,s,c,d),q=b.b,p=H.H(a,q,c,d),o=b.c,n=H.cf(a,o,c,d)
if(r===s&&p===q&&n===o)return b
t=new H.U()
t.a=r
t.b=p
t.c=n
return t},
bm:function(a,b){a[v.arrayRti]=b
return a},
ch:function(a){var t=a.$S
if(t!=null){if(typeof t=="number")return H.bh(t)
return a.$S()}return null},
bi:function(a,b){var t
if(H.aU(b))if(a instanceof H.x){t=H.ch(a)
if(t!=null)return t}return H.J(a)},
J:function(a){var t
if(a instanceof P.h){t=a.$ti
return t!=null?t:H.aE(a)}if(Array.isArray(a))return H.aD(a)
return H.aE(J.ap(a))},
aD:function(a){var t=a[v.arrayRti],s=u.b
if(t==null)return s
if(t.constructor!==s.constructor)return s
return t},
cN:function(a){var t=a.$ti
return t!=null?t:H.aE(a)},
aE:function(a){var t=a.constructor,s=t.$ccache
if(s!=null)return s
return H.c4(a,t)},
c4:function(a,b){var t=a instanceof H.x?a.__proto__.__proto__.constructor:b,s=H.bW(v.typeUniverse,t.name)
b.$ccache=s
return s},
bh:function(a){var t,s,r
H.b5(a)
t=v.types
s=t[a]
if(typeof s=="string"){r=H.aC(v.typeUniverse,s,!1)
t[a]=r
return r}return s},
c3:function(a){var t,s,r=this,q=u.K
if(r===q)return H.G(r,a,H.c7)
if(!H.n(r))if(!(r===u._))q=r===q
else q=!0
else q=!0
if(q)return H.G(r,a,H.cb)
q=r.y
t=q===6?r.z:r
if(t===u.S)s=H.bb
else if(t===u.i||t===u.H)s=H.c6
else if(t===u.N)s=H.c8
else s=t===u.y?H.b9:null
if(s!=null)return H.G(r,a,s)
if(t.y===9){q=t.z
if(t.Q.every(H.cq)){r.r="$i"+q
return H.G(r,a,H.c9)}}else if(q===7)return H.G(r,a,H.c1)
return H.G(r,a,H.c_)},
G:function(a,b,c){a.b=c
return a.b(b)},
c2:function(a){var t,s,r=this
if(!H.n(r))if(!(r===u._))t=r===u.K
else t=!0
else t=!0
if(t)s=H.bZ
else if(r===u.K)s=H.bX
else s=H.c0
r.a=s
return r.a(a)},
cc:function(a){var t,s=a.y
if(!H.n(a))if(!(a===u._))t=a===u.K
else t=!0
else t=!0
return t||a===u.A||s===7||a===u.P||a===u.T},
c_:function(a){var t=this
if(a==null)return H.cc(t)
return H.f(v.typeUniverse,H.bi(a,t),null,t,null)},
c1:function(a){if(a==null)return!0
return this.z.b(a)},
c9:function(a){var t=this,s=t.r
if(a instanceof P.h)return!!a[s]
return!!J.ap(a)[s]},
cM:function(a){var t=this
if(a==null)return a
else if(t.b(a))return a
H.b7(a,t)},
c0:function(a){var t=this
if(a==null)return a
else if(t.b(a))return a
H.b7(a,t)},
b7:function(a,b){throw H.c(H.bN(H.aW(a,H.bi(a,b),H.j(b,null))))},
aW:function(a,b,c){var t=P.a7(a),s=H.j(b==null?H.J(a):b,null)
return t+": type '"+H.d(s)+"' is not a subtype of type '"+H.d(c)+"'"},
bN:function(a){return new H.V("TypeError: "+a)},
i:function(a,b){return new H.V("TypeError: "+H.aW(a,null,b))},
c7:function(a){return a!=null},
bX:function(a){return a},
cb:function(a){return!0},
bZ:function(a){return a},
b9:function(a){return!0===a||!1===a},
cA:function(a){if(!0===a)return!0
if(!1===a)return!1
throw H.c(H.i(a,"bool"))},
cC:function(a){if(!0===a)return!0
if(!1===a)return!1
if(a==null)return a
throw H.c(H.i(a,"bool"))},
cB:function(a){if(!0===a)return!0
if(!1===a)return!1
if(a==null)return a
throw H.c(H.i(a,"bool?"))},
cD:function(a){if(typeof a=="number")return a
throw H.c(H.i(a,"double"))},
cF:function(a){if(typeof a=="number")return a
if(a==null)return a
throw H.c(H.i(a,"double"))},
cE:function(a){if(typeof a=="number")return a
if(a==null)return a
throw H.c(H.i(a,"double?"))},
bb:function(a){return typeof a=="number"&&Math.floor(a)===a},
cG:function(a){if(typeof a=="number"&&Math.floor(a)===a)return a
throw H.c(H.i(a,"int"))},
b5:function(a){if(typeof a=="number"&&Math.floor(a)===a)return a
if(a==null)return a
throw H.c(H.i(a,"int"))},
cH:function(a){if(typeof a=="number"&&Math.floor(a)===a)return a
if(a==null)return a
throw H.c(H.i(a,"int?"))},
c6:function(a){return typeof a=="number"},
cI:function(a){if(typeof a=="number")return a
throw H.c(H.i(a,"num"))},
cK:function(a){if(typeof a=="number")return a
if(a==null)return a
throw H.c(H.i(a,"num"))},
cJ:function(a){if(typeof a=="number")return a
if(a==null)return a
throw H.c(H.i(a,"num?"))},
c8:function(a){return typeof a=="string"},
cL:function(a){if(typeof a=="string")return a
throw H.c(H.i(a,"String"))},
b6:function(a){if(typeof a=="string")return a
if(a==null)return a
throw H.c(H.i(a,"String"))},
bY:function(a){if(typeof a=="string")return a
if(a==null)return a
throw H.c(H.i(a,"String?"))},
cd:function(a,b){var t,s,r
for(t="",s="",r=0;r<a.length;++r,s=", ")t+=C.a.i(s,H.j(a[r],b))
return t},
b8:function(a4,a5,a6){var t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=", "
if(a6!=null){t=a6.length
if(a5==null){a5=H.bm([],u.s)
s=null}else s=a5.length
r=a5.length
for(q=t;q>0;--q)C.e.q(a5,"T"+(r+q))
for(p=u.X,o=u._,n=u.K,m="<",l="",q=0;q<t;++q,l=a3){m+=l
k=a5.length
j=k-1-q
if(j<0)return H.aI(a5,j)
m=C.a.i(m,a5[j])
i=a6[q]
h=i.y
if(!(h===2||h===3||h===4||h===5||i===p))if(!(i===o))k=i===n
else k=!0
else k=!0
if(!k)m+=C.a.i(" extends ",H.j(i,a5))}m+=">"}else{m=""
s=null}p=a4.z
g=a4.Q
f=g.a
e=f.length
d=g.b
c=d.length
b=g.c
a=b.length
a0=H.j(p,a5)
for(a1="",a2="",q=0;q<e;++q,a2=a3)a1+=C.a.i(a2,H.j(f[q],a5))
if(c>0){a1+=a2+"["
for(a2="",q=0;q<c;++q,a2=a3)a1+=C.a.i(a2,H.j(d[q],a5))
a1+="]"}if(a>0){a1+=a2+"{"
for(a2="",q=0;q<a;q+=3,a2=a3){a1+=a2
if(b[q+1])a1+="required "
a1+=J.aK(H.j(b[q+2],a5)," ")+b[q]}a1+="}"}if(s!=null){a5.toString
a5.length=s}return m+"("+a1+") => "+H.d(a0)},
j:function(a,b){var t,s,r,q,p,o,n,m=a.y
if(m===5)return"erased"
if(m===2)return"dynamic"
if(m===3)return"void"
if(m===1)return"Never"
if(m===4)return"any"
if(m===6){t=H.j(a.z,b)
return t}if(m===7){s=a.z
t=H.j(s,b)
r=s.y
return J.aK(r===11||r===12?C.a.i("(",t)+")":t,"?")}if(m===8)return"FutureOr<"+H.d(H.j(a.z,b))+">"
if(m===9){q=H.cg(a.z)
p=a.Q
return p.length!==0?q+("<"+H.cd(p,b)+">"):q}if(m===11)return H.b8(a,b,null)
if(m===12)return H.b8(a.z,b,a.Q)
if(m===13){b.toString
o=a.z
n=b.length
o=n-1-o
if(o<0||o>=n)return H.aI(b,o)
return b[o]}return"?"},
cg:function(a){var t,s=H.bo(a)
if(s!=null)return s
t="minified:"+a
return t},
b3:function(a,b){var t=a.tR[b]
for(;typeof t=="string";)t=a.tR[t]
return t},
bW:function(a,b){var t,s,r,q,p,o=a.eT,n=o[b]
if(n==null)return H.aC(a,b,!1)
else if(typeof n=="number"){t=n
s=H.F(a,5,"#")
r=[]
for(q=0;q<t;++q)r.push(s)
p=H.E(a,b,r)
o[b]=p
return p}else return n},
bU:function(a,b){return H.b4(a.tR,b)},
cz:function(a,b){return H.b4(a.eT,b)},
aC:function(a,b,c){var t,s=a.eC,r=s.get(b)
if(r!=null)return r
t=H.b_(H.aY(a,null,b,c))
s.set(b,t)
return t},
X:function(a,b,c){var t,s,r=b.ch
if(r==null)r=b.ch=new Map()
t=r.get(c)
if(t!=null)return t
s=H.b_(H.aY(a,b,c,!0))
r.set(c,s)
return s},
bV:function(a,b,c){var t,s,r,q=b.cx
if(q==null)q=b.cx=new Map()
t=c.cy
s=q.get(t)
if(s!=null)return s
r=H.az(a,b,c.y===10?c.Q:[c])
q.set(t,r)
return r},
q:function(a,b){b.a=H.c2
b.b=H.c3
return b},
F:function(a,b,c){var t,s,r=a.eC.get(c)
if(r!=null)return r
t=new H.l(null,null)
t.y=b
t.cy=c
s=H.q(a,t)
a.eC.set(c,s)
return s},
b2:function(a,b,c){var t,s=b.cy+"*",r=a.eC.get(s)
if(r!=null)return r
t=H.bS(a,b,s,c)
a.eC.set(s,t)
return t},
bS:function(a,b,c,d){var t,s,r
if(d){t=b.y
if(!H.n(b))s=b===u.P||b===u.T||t===7||t===6
else s=!0
if(s)return b}r=new H.l(null,null)
r.y=6
r.z=b
r.cy=c
return H.q(a,r)},
aB:function(a,b,c){var t,s=b.cy+"?",r=a.eC.get(s)
if(r!=null)return r
t=H.bR(a,b,s,c)
a.eC.set(s,t)
return t},
bR:function(a,b,c,d){var t,s,r,q
if(d){t=b.y
if(!H.n(b))if(!(b===u.P||b===u.T))if(t!==7)s=t===8&&H.au(b.z)
else s=!0
else s=!0
else s=!0
if(s)return b
else if(t===1||b===u.A)return u.P
else if(t===6){r=b.z
if(r.y===8&&H.au(r.z))return r
else return H.bG(a,b)}}q=new H.l(null,null)
q.y=7
q.z=b
q.cy=c
return H.q(a,q)},
b1:function(a,b,c){var t,s=b.cy+"/",r=a.eC.get(s)
if(r!=null)return r
t=H.bP(a,b,s,c)
a.eC.set(s,t)
return t},
bP:function(a,b,c,d){var t,s,r
if(d){t=b.y
if(!H.n(b))if(!(b===u._))s=b===u.K
else s=!0
else s=!0
if(s||b===u.K)return b
else if(t===1)return H.E(a,"aQ",[b])
else if(b===u.P||b===u.T)return u.O}r=new H.l(null,null)
r.y=8
r.z=b
r.cy=c
return H.q(a,r)},
bT:function(a,b){var t,s,r=""+b+"^",q=a.eC.get(r)
if(q!=null)return q
t=new H.l(null,null)
t.y=13
t.z=b
t.cy=r
s=H.q(a,t)
a.eC.set(r,s)
return s},
W:function(a){var t,s,r,q=a.length
for(t="",s="",r=0;r<q;++r,s=",")t+=s+a[r].cy
return t},
bO:function(a){var t,s,r,q,p,o,n=a.length
for(t="",s="",r=0;r<n;r+=3,s=","){q=a[r]
p=a[r+1]?"!":":"
o=a[r+2].cy
t+=s+q+p+o}return t},
E:function(a,b,c){var t,s,r,q=b
if(c.length!==0)q+="<"+H.W(c)+">"
t=a.eC.get(q)
if(t!=null)return t
s=new H.l(null,null)
s.y=9
s.z=b
s.Q=c
if(c.length>0)s.c=c[0]
s.cy=q
r=H.q(a,s)
a.eC.set(q,r)
return r},
az:function(a,b,c){var t,s,r,q,p,o
if(b.y===10){t=b.z
s=b.Q.concat(c)}else{s=c
t=b}r=t.cy+(";<"+H.W(s)+">")
q=a.eC.get(r)
if(q!=null)return q
p=new H.l(null,null)
p.y=10
p.z=t
p.Q=s
p.cy=r
o=H.q(a,p)
a.eC.set(r,o)
return o},
b0:function(a,b,c){var t,s,r,q,p,o=b.cy,n=c.a,m=n.length,l=c.b,k=l.length,j=c.c,i=j.length,h="("+H.W(n)
if(k>0){t=m>0?",":""
s=H.W(l)
h+=t+"["+s+"]"}if(i>0){t=m>0?",":""
s=H.bO(j)
h+=t+"{"+s+"}"}r=o+(h+")")
q=a.eC.get(r)
if(q!=null)return q
p=new H.l(null,null)
p.y=11
p.z=b
p.Q=c
p.cy=r
s=H.q(a,p)
a.eC.set(r,s)
return s},
aA:function(a,b,c,d){var t,s=b.cy+("<"+H.W(c)+">"),r=a.eC.get(s)
if(r!=null)return r
t=H.bQ(a,b,c,s,d)
a.eC.set(s,t)
return t},
bQ:function(a,b,c,d,e){var t,s,r,q,p,o,n,m
if(e){t=c.length
s=new Array(t)
for(r=0,q=0;q<t;++q){p=c[q]
if(p.y===1){s[q]=p;++r}}if(r>0){o=H.r(a,b,s,0)
n=H.H(a,c,s,0)
return H.aA(a,o,n,c!==n)}}m=new H.l(null,null)
m.y=12
m.z=b
m.Q=c
m.cy=d
return H.q(a,m)},
aY:function(a,b,c,d){return{u:a,e:b,r:c,s:[],p:0,n:d}},
b_:function(a){var t,s,r,q,p,o,n,m,l,k,j,i,h=a.r,g=a.s
for(t=h.length,s=0;s<t;){r=h.charCodeAt(s)
if(r>=48&&r<=57)s=H.bJ(s+1,r,h,g)
else if((((r|32)>>>0)-97&65535)<26||r===95||r===36)s=H.aZ(a,s,h,g,!1)
else if(r===46)s=H.aZ(a,s,h,g,!0)
else{++s
switch(r){case 44:break
case 58:g.push(!1)
break
case 33:g.push(!0)
break
case 59:g.push(H.p(a.u,a.e,g.pop()))
break
case 94:g.push(H.bT(a.u,g.pop()))
break
case 35:g.push(H.F(a.u,5,"#"))
break
case 64:g.push(H.F(a.u,2,"@"))
break
case 126:g.push(H.F(a.u,3,"~"))
break
case 60:g.push(a.p)
a.p=g.length
break
case 62:q=a.u
p=g.splice(a.p)
H.ay(a.u,a.e,p)
a.p=g.pop()
o=g.pop()
if(typeof o=="string")g.push(H.E(q,o,p))
else{n=H.p(q,a.e,o)
switch(n.y){case 11:g.push(H.aA(q,n,p,a.n))
break
default:g.push(H.az(q,n,p))
break}}break
case 38:H.bK(a,g)
break
case 42:m=a.u
g.push(H.b2(m,H.p(m,a.e,g.pop()),a.n))
break
case 63:m=a.u
g.push(H.aB(m,H.p(m,a.e,g.pop()),a.n))
break
case 47:m=a.u
g.push(H.b1(m,H.p(m,a.e,g.pop()),a.n))
break
case 40:g.push(a.p)
a.p=g.length
break
case 41:q=a.u
l=new H.U()
k=q.sEA
j=q.sEA
o=g.pop()
if(typeof o=="number")switch(o){case-1:k=g.pop()
break
case-2:j=g.pop()
break
default:g.push(o)
break}else g.push(o)
p=g.splice(a.p)
H.ay(a.u,a.e,p)
a.p=g.pop()
l.a=p
l.b=k
l.c=j
g.push(H.b0(q,H.p(q,a.e,g.pop()),l))
break
case 91:g.push(a.p)
a.p=g.length
break
case 93:p=g.splice(a.p)
H.ay(a.u,a.e,p)
a.p=g.pop()
g.push(p)
g.push(-1)
break
case 123:g.push(a.p)
a.p=g.length
break
case 125:p=g.splice(a.p)
H.bM(a.u,a.e,p)
a.p=g.pop()
g.push(p)
g.push(-2)
break
default:throw"Bad character "+r}}}i=g.pop()
return H.p(a.u,a.e,i)},
bJ:function(a,b,c,d){var t,s,r=b-48
for(t=c.length;a<t;++a){s=c.charCodeAt(a)
if(!(s>=48&&s<=57))break
r=r*10+(s-48)}d.push(r)
return a},
aZ:function(a,b,c,d,e){var t,s,r,q,p,o,n=b+1
for(t=c.length;n<t;++n){s=c.charCodeAt(n)
if(s===46){if(e)break
e=!0}else{if(!((((s|32)>>>0)-97&65535)<26||s===95||s===36))r=s>=48&&s<=57
else r=!0
if(!r)break}}q=c.substring(b,n)
if(e){t=a.u
p=a.e
if(p.y===10)p=p.z
o=H.b3(t,p.z)[q]
if(o==null)H.bn('No "'+q+'" in "'+H.bF(p)+'"')
d.push(H.X(t,p,o))}else d.push(q)
return n},
bK:function(a,b){var t=b.pop()
if(0===t){b.push(H.F(a.u,1,"0&"))
return}if(1===t){b.push(H.F(a.u,4,"1&"))
return}throw H.c(P.a2("Unexpected extended operation "+H.d(t)))},
p:function(a,b,c){if(typeof c=="string")return H.E(a,c,a.sEA)
else if(typeof c=="number")return H.bL(a,b,c)
else return c},
ay:function(a,b,c){var t,s=c.length
for(t=0;t<s;++t)c[t]=H.p(a,b,c[t])},
bM:function(a,b,c){var t,s=c.length
for(t=2;t<s;t+=3)c[t]=H.p(a,b,c[t])},
bL:function(a,b,c){var t,s,r=b.y
if(r===10){if(c===0)return b.z
t=b.Q
s=t.length
if(c<=s)return t[c-1]
c-=s
b=b.z
r=b.y}else if(c===0)return b
if(r!==9)throw H.c(P.a2("Indexed base must be an interface type"))
t=b.Q
if(c<=t.length)return t[c-1]
throw H.c(P.a2("Bad index "+c+" for "+b.h(0)))},
f:function(a,b,c,d,e){var t,s,r,q,p,o,n,m,l,k
if(b===d)return!0
if(!H.n(d))if(!(d===u._))t=d===u.K
else t=!0
else t=!0
if(t)return!0
s=b.y
if(s===4)return!0
if(H.n(b))return!1
if(b.y!==1)t=b===u.P||b===u.T
else t=!0
if(t)return!0
r=s===13
if(r)if(H.f(a,c[b.z],c,d,e))return!0
q=d.y
if(s===6)return H.f(a,b.z,c,d,e)
if(q===6){t=d.z
return H.f(a,b,c,t,e)}if(s===8){if(!H.f(a,b.z,c,d,e))return!1
return H.f(a,H.aT(a,b),c,d,e)}if(s===7){t=H.f(a,b.z,c,d,e)
return t}if(q===8){if(H.f(a,b,c,d.z,e))return!0
return H.f(a,b,c,H.aT(a,d),e)}if(q===7){t=H.f(a,b,c,d.z,e)
return t}if(r)return!1
t=s!==11
if((!t||s===12)&&d===u.Z)return!0
if(q===12){if(b===u.g)return!0
if(s!==12)return!1
p=b.Q
o=d.Q
n=p.length
if(n!==o.length)return!1
c=c==null?p:p.concat(c)
e=e==null?o:o.concat(e)
for(m=0;m<n;++m){l=p[m]
k=o[m]
if(!H.f(a,l,c,k,e)||!H.f(a,k,e,l,c))return!1}return H.ba(a,b.z,c,d.z,e)}if(q===11){if(b===u.g)return!0
if(t)return!1
return H.ba(a,b,c,d,e)}if(s===9){if(q!==9)return!1
return H.c5(a,b,c,d,e)}return!1},
ba:function(a2,a3,a4,a5,a6){var t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1
if(!H.f(a2,a3.z,a4,a5.z,a6))return!1
t=a3.Q
s=a5.Q
r=t.a
q=s.a
p=r.length
o=q.length
if(p>o)return!1
n=o-p
m=t.b
l=s.b
k=m.length
j=l.length
if(p+k<o+j)return!1
for(i=0;i<p;++i){h=r[i]
if(!H.f(a2,q[i],a6,h,a4))return!1}for(i=0;i<n;++i){h=m[i]
if(!H.f(a2,q[p+i],a6,h,a4))return!1}for(i=0;i<j;++i){h=m[n+i]
if(!H.f(a2,l[i],a6,h,a4))return!1}g=t.c
f=s.c
e=g.length
d=f.length
for(c=0,b=0;b<d;b+=3){a=f[b]
for(;!0;){if(c>=e)return!1
a0=g[c]
c+=3
if(a<a0)return!1
a1=g[c-2]
if(a0<a){if(a1)return!1
continue}h=f[b+1]
if(a1&&!h)return!1
h=g[c-1]
if(!H.f(a2,f[b+2],a6,h,a4))return!1
break}}for(;c<e;){if(g[c+1])return!1
c+=3}return!0},
c5:function(a,b,c,d,e){var t,s,r,q,p,o,n,m,l=b.z,k=d.z
if(l===k){t=b.Q
s=d.Q
r=t.length
for(q=0;q<r;++q){p=t[q]
o=s[q]
if(!H.f(a,p,c,o,e))return!1}return!0}if(d===u.K)return!0
n=H.b3(a,l)
if(n==null)return!1
m=n[k]
if(m==null)return!1
r=m.length
s=d.Q
for(q=0;q<r;++q)if(!H.f(a,H.X(a,b,m[q]),c,s[q],e))return!1
return!0},
au:function(a){var t,s=a.y
if(!(a===u.P||a===u.T))if(!H.n(a))if(s!==7)if(!(s===6&&H.au(a.z)))t=s===8&&H.au(a.z)
else t=!0
else t=!0
else t=!0
else t=!0
return t},
cq:function(a){var t
if(!H.n(a))if(!(a===u._))t=a===u.K
else t=!0
else t=!0
return t},
n:function(a){var t=a.y
return t===2||t===3||t===4||t===5||a===u.X},
b4:function(a,b){var t,s,r=Object.keys(b),q=r.length
for(t=0;t<q;++t){s=r[t]
a[s]=b[s]}},
l:function l(a,b){var _=this
_.a=a
_.b=b
_.x=_.r=_.c=null
_.y=0
_.cy=_.cx=_.ch=_.Q=_.z=null},
U:function U(){this.c=this.b=this.a=null},
an:function an(){},
V:function V(a){this.a=a},
bo:function(a){return v.mangledGlobalNames[a]}},J={
aJ:function(a,b,c,d){return{i:a,p:b,e:c,x:d}},
aG:function(a){var t,s,r,q,p=a[v.dispatchPropertyName]
if(p==null)if($.aH==null){H.co()
p=a[v.dispatchPropertyName]}if(p!=null){t=p.p
if(!1===t)return p.i
if(!0===t)return a
s=Object.getPrototypeOf(a)
if(t===s)return p.i
if(p.e===s)throw H.c(P.aV("Return interceptor for "+H.d(t(a,p))))}r=a.constructor
q=r==null?null:r[J.aR()]
if(q!=null)return q
q=H.cr(a)
if(q!=null)return q
if(typeof a=="function")return C.o
t=Object.getPrototypeOf(a)
if(t==null)return C.f
if(t===Object.prototype)return C.f
if(typeof r=="function"){Object.defineProperty(r,J.aR(),{value:C.b,enumerable:false,writable:true,configurable:true})
return C.b}return C.b},
aR:function(){var t=$.aX
return t==null?$.aX=v.getIsolateTag("_$dart_js"):t},
ap:function(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.P.prototype
return J.ab.prototype}if(typeof a=="string")return J.u.prototype
if(a==null)return J.Q.prototype
if(typeof a=="boolean")return J.O.prototype
if(a.constructor==Array)return J.k.prototype
if(typeof a!="object"){if(typeof a=="function")return J.o.prototype
return a}if(a instanceof P.h)return a
return J.aG(a)},
bf:function(a){if(typeof a=="string")return J.u.prototype
if(a==null)return a
if(a.constructor==Array)return J.k.prototype
if(typeof a!="object"){if(typeof a=="function")return J.o.prototype
return a}if(a instanceof P.h)return a
return J.aG(a)},
cj:function(a){if(typeof a=="number")return J.R.prototype
if(typeof a=="string")return J.u.prototype
if(a==null)return a
if(!(a instanceof P.h))return J.z.prototype
return a},
ck:function(a){if(a==null)return a
if(typeof a!="object"){if(typeof a=="function")return J.o.prototype
return a}if(a instanceof P.h)return a
return J.aG(a)},
aK:function(a,b){if(typeof a=="number"&&typeof b=="number")return a+b
return J.cj(a).i(a,b)},
br:function(a){return J.bf(a).gj(a)},
bs:function(a,b){return J.ck(a).sv(a,b)},
Z:function(a){return J.ap(a).h(a)},
e:function e(){},
O:function O(){},
Q:function Q(){},
v:function v(){},
T:function T(){},
z:function z(){},
o:function o(){},
k:function k(a){this.$ti=a},
ac:function ac(a){this.$ti=a},
L:function L(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
R:function R(){},
P:function P(){},
ab:function ab(){},
u:function u(){}},P={
bC:function(a){if(a instanceof H.x)return a.h(0)
return"Instance of '"+H.d(H.ae(a))+"'"},
bH:function(a,b,c){var t=new J.L(b,b.length,H.aD(b).p("L<1>"))
if(!t.m())return a
if(c.length===0){do a+=H.d(t.d)
while(t.m())}else{a+=H.d(t.d)
for(;t.m();)a=a+c+H.d(t.d)}return a},
a7:function(a){if(typeof a=="number"||H.b9(a)||null==a)return J.Z(a)
if(typeof a=="string")return JSON.stringify(a)
return P.bC(a)},
a2:function(a){return new P.a1(a)},
bt:function(a,b,c){return new P.t(!0,a,b,c)},
bI:function(a){return new P.am(a)},
aV:function(a){return new P.al(a)},
B:function B(){},
Y:function Y(){},
a6:function a6(){},
a1:function a1(a){this.a=a},
ad:function ad(){},
t:function t(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
af:function af(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
a9:function a9(a,b,c,d,e){var _=this
_.f=a
_.a=b
_.b=c
_.c=d
_.d=e},
am:function am(a){this.a=a},
al:function al(a){this.a=a},
a3:function a3(a){this.a=a},
a4:function a4(a){this.a=a},
C:function C(){},
S:function S(){},
D:function D(){},
K:function K(){},
h:function h(){},
w:function w(){},
aj:function aj(a){this.a=a},
bD:function(a,b,c){var t,s
if(P.ca(a))return b+"..."+c
t=new P.aj(b)
C.e.q($.I,a)
try{s=t
s.a=P.bH(s.a,a,", ")}finally{if(0>=$.I.length)return H.aI($.I,-1)
$.I.pop()}t.a+=c
s=t.a
return s.charCodeAt(0)==0?s:s},
ca:function(a){var t,s
for(t=$.I.length,s=0;s<t;++s)if(a===$.I[s])return!0
return!1}},W={b:function b(){},a_:function a_(){},a0:function a0(){},a5:function a5(){},a:function a(){},N:function N(){},a8:function a8(){},y:function y(){},ah:function ah(){}},F={
bj:function(){J.bs(document.querySelector("#output"),"Your Blaseball Playoff Status app is running.")}}
var w=[C,H,J,P,W,F]
hunkHelpers.setFunctionNamesIfNecessary(w)
var $={}
H.ax.prototype={}
J.e.prototype={
h:function(a){return"Instance of '"+H.d(H.ae(a))+"'"}}
J.O.prototype={
h:function(a){return String(a)},
$iB:1}
J.Q.prototype={
h:function(a){return"null"}}
J.v.prototype={
h:function(a){return String(a)}}
J.T.prototype={}
J.z.prototype={}
J.o.prototype={
h:function(a){var t=a[$.bq()]
if(t==null)return this.u(a)
return"JavaScript function for "+H.d(J.Z(t))}}
J.k.prototype={
q:function(a,b){H.aD(a).c.a(b)
if(!!a.fixed$length)H.bn(P.bI("add"))
a.push(b)},
h:function(a){return P.bD(a,"[","]")},
gj:function(a){return a.length},
$iaa:1}
J.ac.prototype={}
J.L.prototype={
m:function(){var t,s=this,r=s.a,q=r.length
if(s.b!==q)throw H.c(H.ct(r))
t=s.c
if(t>=q){s.sn(null)
return!1}s.sn(r[t]);++s.c
return!0},
sn:function(a){this.d=this.$ti.p("1?").a(a)}}
J.R.prototype={
h:function(a){if(a===0&&1/a<0)return"-0.0"
else return""+a}}
J.P.prototype={$iC:1}
J.ab.prototype={}
J.u.prototype={
i:function(a,b){if(typeof b!="string")throw H.c(P.bt(b,null,null))
return a+b},
h:function(a){return a},
gj:function(a){return a.length},
$iw:1}
H.x.prototype={
h:function(a){var t=this.constructor,s=t==null?null:t.name
return"Closure '"+H.bp(s==null?"unknown":s)+"'"},
gw:function(){return this},
$C:"$1",
$R:1,
$D:null}
H.ak.prototype={}
H.ai.prototype={
h:function(a){var t=this.$static_name
if(t==null)return"Closure of unknown static method"
return"Closure '"+H.bp(t)+"'"}}
H.M.prototype={
h:function(a){var t=this.c
if(t==null)t=this.a
return"Closure '"+H.d(this.d)+"' of "+("Instance of '"+H.d(H.ae(t))+"'")}}
H.ag.prototype={
h:function(a){return"RuntimeError: "+this.a}}
H.aq.prototype={
$1:function(a){return this.a(a)}}
H.ar.prototype={
$2:function(a,b){return this.a(a,b)}}
H.as.prototype={
$1:function(a){return this.a(H.b6(a))}}
H.l.prototype={
p:function(a){return H.X(v.typeUniverse,this,a)},
B:function(a){return H.bV(v.typeUniverse,this,a)}}
H.U.prototype={}
H.an.prototype={
h:function(a){return this.a}}
H.V.prototype={}
P.B.prototype={
h:function(a){return this?"true":"false"}}
P.Y.prototype={}
P.a6.prototype={}
P.a1.prototype={
h:function(a){var t=this.a
if(t!=null)return"Assertion failed: "+P.a7(t)
return"Assertion failed"}}
P.ad.prototype={
h:function(a){return"Throw of null."}}
P.t.prototype={
gl:function(){return"Invalid argument"+(!this.a?"(s)":"")},
gk:function(){return""},
h:function(a){var t,s,r=this,q=r.c,p=q==null?"":" ("+q+")",o=r.d,n=o==null?"":": "+o,m=r.gl()+p+n
if(!r.a)return m
t=r.gk()
s=P.a7(r.b)
return m+t+": "+s}}
P.af.prototype={
gl:function(){return"RangeError"},
gk:function(){return""}}
P.a9.prototype={
gl:function(){return"RangeError"},
gk:function(){var t,s=H.b5(this.b)
if(typeof s!=="number")return s.A()
if(s<0)return": index must not be negative"
t=this.f
if(t===0)return": no indices are valid"
return": index should be less than "+H.d(t)},
gj:function(a){return this.f}}
P.am.prototype={
h:function(a){return"Unsupported operation: "+this.a}}
P.al.prototype={
h:function(a){var t=this.a
return t!=null?"UnimplementedError: "+t:"UnimplementedError"}}
P.a3.prototype={
h:function(a){return"Concurrent modification during iteration: "+P.a7(this.a)+"."}}
P.a4.prototype={
h:function(a){var t=this.a
return t==null?"Reading static variable during its initialization":"Reading static variable '"+t+"' during its initialization"}}
P.C.prototype={}
P.S.prototype={$iaa:1}
P.D.prototype={
h:function(a){return"null"}}
P.K.prototype={}
P.h.prototype={constructor:P.h,$ih:1,
h:function(a){return"Instance of '"+H.d(H.ae(this))+"'"},
toString:function(){return this.h(this)}}
P.w.prototype={}
P.aj.prototype={
gj:function(a){return this.a.length},
h:function(a){var t=this.a
return t.charCodeAt(0)==0?t:t}}
W.b.prototype={}
W.a_.prototype={
h:function(a){return String(a)}}
W.a0.prototype={
h:function(a){return String(a)}}
W.a5.prototype={
h:function(a){return String(a)}}
W.a.prototype={
h:function(a){return a.localName}}
W.N.prototype={}
W.a8.prototype={
gj:function(a){return a.length}}
W.y.prototype={
h:function(a){var t=a.nodeValue
return t==null?this.t(a):t},
sv:function(a,b){a.textContent=b}}
W.ah.prototype={
gj:function(a){return a.length}};(function aliases(){var t=J.e.prototype
t.t=t.h
t=J.v.prototype
t.u=t.h})();(function inheritance(){var t=hunkHelpers.inherit,s=hunkHelpers.inheritMany
t(P.h,null)
s(P.h,[H.ax,J.e,J.L,H.x,P.a6,H.l,H.U,P.B,P.K,P.S,P.D,P.w,P.aj])
s(J.e,[J.O,J.Q,J.v,J.k,J.R,J.u,W.N,W.a5])
s(J.v,[J.T,J.z,J.o])
t(J.ac,J.k)
s(J.R,[J.P,J.ab])
s(H.x,[H.ak,H.aq,H.ar,H.as])
s(H.ak,[H.ai,H.M])
s(P.a6,[H.ag,H.an,P.a1,P.ad,P.t,P.am,P.al,P.a3,P.a4])
t(H.V,H.an)
s(P.K,[P.Y,P.C])
s(P.t,[P.af,P.a9])
t(W.y,W.N)
t(W.a,W.y)
t(W.b,W.a)
s(W.b,[W.a_,W.a0,W.a8,W.ah])})()
var v={typeUniverse:{eC:new Map(),tR:{},eT:{},tPV:{},sEA:[]},mangledGlobalNames:{C:"int",Y:"double",K:"num",w:"String",B:"bool",D:"Null",S:"List"},mangledNames:{},getTypeFromName:getGlobalFromName,metadata:[],types:[],interceptorsByTag:null,leafTags:null,arrayRti:typeof Symbol=="function"&&typeof Symbol()=="symbol"?Symbol("$ti"):"$ti"}
H.bU(v.typeUniverse,JSON.parse('{"T":"v","z":"v","o":"v","O":{"B":[]},"k":{"aa":["1"]},"ac":{"k":["1"],"aa":["1"]},"P":{"C":[]},"u":{"w":[]},"S":{"aa":["1"]}}'))
0
var u=(function rtii(){var t=H.be
return{Z:t("cx"),s:t("k<w>"),b:t("k<@>"),T:t("Q"),g:t("o"),P:t("D"),K:t("h"),N:t("w"),o:t("z"),y:t("B"),i:t("Y"),S:t("C"),A:t("0&*"),_:t("h*"),O:t("aQ<D>?"),X:t("h?"),H:t("K")}})();(function constants(){C.n=J.e.prototype
C.e=J.k.prototype
C.a=J.u.prototype
C.o=J.o.prototype
C.f=J.T.prototype
C.b=J.z.prototype
C.c=function getTagFallback(o) {
  var s = Object.prototype.toString.call(o);
  return s.substring(8, s.length - 1);
}
C.h=function() {
  var toStringFunction = Object.prototype.toString;
  function getTag(o) {
    var s = toStringFunction.call(o);
    return s.substring(8, s.length - 1);
  }
  function getUnknownTag(object, tag) {
    if (/^HTML[A-Z].*Element$/.test(tag)) {
      var name = toStringFunction.call(object);
      if (name == "[object Object]") return null;
      return "HTMLElement";
    }
  }
  function getUnknownTagGenericBrowser(object, tag) {
    if (self.HTMLElement && object instanceof HTMLElement) return "HTMLElement";
    return getUnknownTag(object, tag);
  }
  function prototypeForTag(tag) {
    if (typeof window == "undefined") return null;
    if (typeof window[tag] == "undefined") return null;
    var constructor = window[tag];
    if (typeof constructor != "function") return null;
    return constructor.prototype;
  }
  function discriminator(tag) { return null; }
  var isBrowser = typeof navigator == "object";
  return {
    getTag: getTag,
    getUnknownTag: isBrowser ? getUnknownTagGenericBrowser : getUnknownTag,
    prototypeForTag: prototypeForTag,
    discriminator: discriminator };
}
C.m=function(getTagFallback) {
  return function(hooks) {
    if (typeof navigator != "object") return hooks;
    var ua = navigator.userAgent;
    if (ua.indexOf("DumpRenderTree") >= 0) return hooks;
    if (ua.indexOf("Chrome") >= 0) {
      function confirm(p) {
        return typeof window == "object" && window[p] && window[p].name == p;
      }
      if (confirm("Window") && confirm("HTMLElement")) return hooks;
    }
    hooks.getTag = getTagFallback;
  };
}
C.i=function(hooks) {
  if (typeof dartExperimentalFixupGetTag != "function") return hooks;
  hooks.getTag = dartExperimentalFixupGetTag(hooks.getTag);
}
C.j=function(hooks) {
  var getTag = hooks.getTag;
  var prototypeForTag = hooks.prototypeForTag;
  function getTagFixed(o) {
    var tag = getTag(o);
    if (tag == "Document") {
      if (!!o.xmlVersion) return "!Document";
      return "!HTMLDocument";
    }
    return tag;
  }
  function prototypeForTagFixed(tag) {
    if (tag == "Document") return null;
    return prototypeForTag(tag);
  }
  hooks.getTag = getTagFixed;
  hooks.prototypeForTag = prototypeForTagFixed;
}
C.l=function(hooks) {
  var userAgent = typeof navigator == "object" ? navigator.userAgent : "";
  if (userAgent.indexOf("Firefox") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "GeoGeolocation": "Geolocation",
    "Location": "!Location",
    "WorkerMessageEvent": "MessageEvent",
    "XMLDocument": "!Document"};
  function getTagFirefox(o) {
    var tag = getTag(o);
    return quickMap[tag] || tag;
  }
  hooks.getTag = getTagFirefox;
}
C.k=function(hooks) {
  var userAgent = typeof navigator == "object" ? navigator.userAgent : "";
  if (userAgent.indexOf("Trident/") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "HTMLDDElement": "HTMLElement",
    "HTMLDTElement": "HTMLElement",
    "HTMLPhraseElement": "HTMLElement",
    "Position": "Geoposition"
  };
  function getTagIE(o) {
    var tag = getTag(o);
    var newTag = quickMap[tag];
    if (newTag) return newTag;
    if (tag == "Object") {
      if (window.DataView && (o instanceof window.DataView)) return "DataView";
    }
    return tag;
  }
  function prototypeForTagIE(tag) {
    var constructor = window[tag];
    if (constructor == null) return null;
    return constructor.prototype;
  }
  hooks.getTag = getTagIE;
  hooks.prototypeForTag = prototypeForTagIE;
}
C.d=function(hooks) { return hooks; }
})();(function staticFields(){$.aX=null
$.m=0
$.aN=null
$.aM=null
$.bg=null
$.bc=null
$.bl=null
$.ao=null
$.at=null
$.aH=null
$.I=H.bm([],H.be("k<h>"))})();(function lazyInitializers(){var t=hunkHelpers.lazy
t($,"cw","bq",function(){return H.cl("_$dart_dartClosure")})})();(function nativeSupport(){!function(){var t=function(a){var n={}
n[a]=1
return Object.keys(hunkHelpers.convertToFastObject(n))[0]}
v.getIsolateTag=function(a){return t("___dart_"+a+v.isolateTag)}
var s="___dart_isolate_tags_"
var r=Object[s]||(Object[s]=Object.create(null))
var q="_ZxYxX"
for(var p=0;;p++){var o=t(q+"_"+p+"_")
if(!(o in r)){r[o]=1
v.isolateTag=o
break}}v.dispatchPropertyName=v.getIsolateTag("dispatch_record")}()
hunkHelpers.setOrUpdateInterceptorsByTag({ApplicationCacheErrorEvent:J.e,DOMError:J.e,ErrorEvent:J.e,Event:J.e,InputEvent:J.e,SubmitEvent:J.e,MediaError:J.e,NavigatorUserMediaError:J.e,OverconstrainedError:J.e,PositionError:J.e,SensorErrorEvent:J.e,SpeechRecognitionError:J.e,SQLError:J.e,HTMLAudioElement:W.b,HTMLBRElement:W.b,HTMLBaseElement:W.b,HTMLBodyElement:W.b,HTMLButtonElement:W.b,HTMLCanvasElement:W.b,HTMLContentElement:W.b,HTMLDListElement:W.b,HTMLDataElement:W.b,HTMLDataListElement:W.b,HTMLDetailsElement:W.b,HTMLDialogElement:W.b,HTMLDivElement:W.b,HTMLEmbedElement:W.b,HTMLFieldSetElement:W.b,HTMLHRElement:W.b,HTMLHeadElement:W.b,HTMLHeadingElement:W.b,HTMLHtmlElement:W.b,HTMLIFrameElement:W.b,HTMLImageElement:W.b,HTMLInputElement:W.b,HTMLLIElement:W.b,HTMLLabelElement:W.b,HTMLLegendElement:W.b,HTMLLinkElement:W.b,HTMLMapElement:W.b,HTMLMediaElement:W.b,HTMLMenuElement:W.b,HTMLMetaElement:W.b,HTMLMeterElement:W.b,HTMLModElement:W.b,HTMLOListElement:W.b,HTMLObjectElement:W.b,HTMLOptGroupElement:W.b,HTMLOptionElement:W.b,HTMLOutputElement:W.b,HTMLParagraphElement:W.b,HTMLParamElement:W.b,HTMLPictureElement:W.b,HTMLPreElement:W.b,HTMLProgressElement:W.b,HTMLQuoteElement:W.b,HTMLScriptElement:W.b,HTMLShadowElement:W.b,HTMLSlotElement:W.b,HTMLSourceElement:W.b,HTMLSpanElement:W.b,HTMLStyleElement:W.b,HTMLTableCaptionElement:W.b,HTMLTableCellElement:W.b,HTMLTableDataCellElement:W.b,HTMLTableHeaderCellElement:W.b,HTMLTableColElement:W.b,HTMLTableElement:W.b,HTMLTableRowElement:W.b,HTMLTableSectionElement:W.b,HTMLTemplateElement:W.b,HTMLTextAreaElement:W.b,HTMLTimeElement:W.b,HTMLTitleElement:W.b,HTMLTrackElement:W.b,HTMLUListElement:W.b,HTMLUnknownElement:W.b,HTMLVideoElement:W.b,HTMLDirectoryElement:W.b,HTMLFontElement:W.b,HTMLFrameElement:W.b,HTMLFrameSetElement:W.b,HTMLMarqueeElement:W.b,HTMLElement:W.b,HTMLAnchorElement:W.a_,HTMLAreaElement:W.a0,DOMException:W.a5,SVGAElement:W.a,SVGAnimateElement:W.a,SVGAnimateMotionElement:W.a,SVGAnimateTransformElement:W.a,SVGAnimationElement:W.a,SVGCircleElement:W.a,SVGClipPathElement:W.a,SVGDefsElement:W.a,SVGDescElement:W.a,SVGDiscardElement:W.a,SVGEllipseElement:W.a,SVGFEBlendElement:W.a,SVGFEColorMatrixElement:W.a,SVGFEComponentTransferElement:W.a,SVGFECompositeElement:W.a,SVGFEConvolveMatrixElement:W.a,SVGFEDiffuseLightingElement:W.a,SVGFEDisplacementMapElement:W.a,SVGFEDistantLightElement:W.a,SVGFEFloodElement:W.a,SVGFEFuncAElement:W.a,SVGFEFuncBElement:W.a,SVGFEFuncGElement:W.a,SVGFEFuncRElement:W.a,SVGFEGaussianBlurElement:W.a,SVGFEImageElement:W.a,SVGFEMergeElement:W.a,SVGFEMergeNodeElement:W.a,SVGFEMorphologyElement:W.a,SVGFEOffsetElement:W.a,SVGFEPointLightElement:W.a,SVGFESpecularLightingElement:W.a,SVGFESpotLightElement:W.a,SVGFETileElement:W.a,SVGFETurbulenceElement:W.a,SVGFilterElement:W.a,SVGForeignObjectElement:W.a,SVGGElement:W.a,SVGGeometryElement:W.a,SVGGraphicsElement:W.a,SVGImageElement:W.a,SVGLineElement:W.a,SVGLinearGradientElement:W.a,SVGMarkerElement:W.a,SVGMaskElement:W.a,SVGMetadataElement:W.a,SVGPathElement:W.a,SVGPatternElement:W.a,SVGPolygonElement:W.a,SVGPolylineElement:W.a,SVGRadialGradientElement:W.a,SVGRectElement:W.a,SVGScriptElement:W.a,SVGSetElement:W.a,SVGStopElement:W.a,SVGStyleElement:W.a,SVGElement:W.a,SVGSVGElement:W.a,SVGSwitchElement:W.a,SVGSymbolElement:W.a,SVGTSpanElement:W.a,SVGTextContentElement:W.a,SVGTextElement:W.a,SVGTextPathElement:W.a,SVGTextPositioningElement:W.a,SVGTitleElement:W.a,SVGUseElement:W.a,SVGViewElement:W.a,SVGGradientElement:W.a,SVGComponentTransferFunctionElement:W.a,SVGFEDropShadowElement:W.a,SVGMPathElement:W.a,Element:W.a,EventTarget:W.N,HTMLFormElement:W.a8,Document:W.y,HTMLDocument:W.y,Node:W.y,HTMLSelectElement:W.ah})
hunkHelpers.setOrUpdateLeafTags({ApplicationCacheErrorEvent:true,DOMError:true,ErrorEvent:true,Event:true,InputEvent:true,SubmitEvent:true,MediaError:true,NavigatorUserMediaError:true,OverconstrainedError:true,PositionError:true,SensorErrorEvent:true,SpeechRecognitionError:true,SQLError:true,HTMLAudioElement:true,HTMLBRElement:true,HTMLBaseElement:true,HTMLBodyElement:true,HTMLButtonElement:true,HTMLCanvasElement:true,HTMLContentElement:true,HTMLDListElement:true,HTMLDataElement:true,HTMLDataListElement:true,HTMLDetailsElement:true,HTMLDialogElement:true,HTMLDivElement:true,HTMLEmbedElement:true,HTMLFieldSetElement:true,HTMLHRElement:true,HTMLHeadElement:true,HTMLHeadingElement:true,HTMLHtmlElement:true,HTMLIFrameElement:true,HTMLImageElement:true,HTMLInputElement:true,HTMLLIElement:true,HTMLLabelElement:true,HTMLLegendElement:true,HTMLLinkElement:true,HTMLMapElement:true,HTMLMediaElement:true,HTMLMenuElement:true,HTMLMetaElement:true,HTMLMeterElement:true,HTMLModElement:true,HTMLOListElement:true,HTMLObjectElement:true,HTMLOptGroupElement:true,HTMLOptionElement:true,HTMLOutputElement:true,HTMLParagraphElement:true,HTMLParamElement:true,HTMLPictureElement:true,HTMLPreElement:true,HTMLProgressElement:true,HTMLQuoteElement:true,HTMLScriptElement:true,HTMLShadowElement:true,HTMLSlotElement:true,HTMLSourceElement:true,HTMLSpanElement:true,HTMLStyleElement:true,HTMLTableCaptionElement:true,HTMLTableCellElement:true,HTMLTableDataCellElement:true,HTMLTableHeaderCellElement:true,HTMLTableColElement:true,HTMLTableElement:true,HTMLTableRowElement:true,HTMLTableSectionElement:true,HTMLTemplateElement:true,HTMLTextAreaElement:true,HTMLTimeElement:true,HTMLTitleElement:true,HTMLTrackElement:true,HTMLUListElement:true,HTMLUnknownElement:true,HTMLVideoElement:true,HTMLDirectoryElement:true,HTMLFontElement:true,HTMLFrameElement:true,HTMLFrameSetElement:true,HTMLMarqueeElement:true,HTMLElement:false,HTMLAnchorElement:true,HTMLAreaElement:true,DOMException:true,SVGAElement:true,SVGAnimateElement:true,SVGAnimateMotionElement:true,SVGAnimateTransformElement:true,SVGAnimationElement:true,SVGCircleElement:true,SVGClipPathElement:true,SVGDefsElement:true,SVGDescElement:true,SVGDiscardElement:true,SVGEllipseElement:true,SVGFEBlendElement:true,SVGFEColorMatrixElement:true,SVGFEComponentTransferElement:true,SVGFECompositeElement:true,SVGFEConvolveMatrixElement:true,SVGFEDiffuseLightingElement:true,SVGFEDisplacementMapElement:true,SVGFEDistantLightElement:true,SVGFEFloodElement:true,SVGFEFuncAElement:true,SVGFEFuncBElement:true,SVGFEFuncGElement:true,SVGFEFuncRElement:true,SVGFEGaussianBlurElement:true,SVGFEImageElement:true,SVGFEMergeElement:true,SVGFEMergeNodeElement:true,SVGFEMorphologyElement:true,SVGFEOffsetElement:true,SVGFEPointLightElement:true,SVGFESpecularLightingElement:true,SVGFESpotLightElement:true,SVGFETileElement:true,SVGFETurbulenceElement:true,SVGFilterElement:true,SVGForeignObjectElement:true,SVGGElement:true,SVGGeometryElement:true,SVGGraphicsElement:true,SVGImageElement:true,SVGLineElement:true,SVGLinearGradientElement:true,SVGMarkerElement:true,SVGMaskElement:true,SVGMetadataElement:true,SVGPathElement:true,SVGPatternElement:true,SVGPolygonElement:true,SVGPolylineElement:true,SVGRadialGradientElement:true,SVGRectElement:true,SVGScriptElement:true,SVGSetElement:true,SVGStopElement:true,SVGStyleElement:true,SVGElement:true,SVGSVGElement:true,SVGSwitchElement:true,SVGSymbolElement:true,SVGTSpanElement:true,SVGTextContentElement:true,SVGTextElement:true,SVGTextPathElement:true,SVGTextPositioningElement:true,SVGTitleElement:true,SVGUseElement:true,SVGViewElement:true,SVGGradientElement:true,SVGComponentTransferFunctionElement:true,SVGFEDropShadowElement:true,SVGMPathElement:true,Element:false,EventTarget:false,HTMLFormElement:true,Document:true,HTMLDocument:true,Node:false,HTMLSelectElement:true})})()
convertAllToFastObject(w)
convertToFastObject($);(function(a){if(typeof document==="undefined"){a(null)
return}if(typeof document.currentScript!='undefined'){a(document.currentScript)
return}var t=document.scripts
function onLoad(b){for(var r=0;r<t.length;++r)t[r].removeEventListener("load",onLoad,false)
a(b.target)}for(var s=0;s<t.length;++s)t[s].addEventListener("load",onLoad,false)})(function(a){v.currentScript=a
if(typeof dartMainRunner==="function")dartMainRunner(F.bj,[])
else F.bj([])})})()
//# sourceMappingURL=main.dart.js.map
