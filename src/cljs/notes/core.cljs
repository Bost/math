(ns notes.core
  (:require
   [reagent.core :as reagent]
   [re-frame.core :as re-frame]
   [re-pressed.core :as rp]
   [notes.collapsible :as collapse]
   [notes.events :as events]
   [notes.views :as views]
   [notes.config :as config]
   [katex :as k :refer [render renderToString renderMathInElement]]
   [goog.dom :as dom]
   [domina :as domina]
   ))

(enable-console-print!)

(defn dev-setup []
  (when config/debug?
    (enable-console-print!)
    (println "dev mode")))

(defn render-math [{:keys [id expr]}]
  (let [elem (.getElementById js/document id)]
    (k/render expr elem)
    (js/renderMathInElement elem)))

;; see LightTable/src/lt/util/dom.cljs
(defn lazy-nl-via-item
  ([nl] (lazy-nl-via-item nl 0))
  ([nl n] (when (< n (. nl -length))
            (lazy-seq
             (cons (. nl (item n))
                   (lazy-nl-via-item nl (inc n)))))))

(defn mount-root []
  (re-frame/clear-subscription-cache!)
  (let [app-elem (dom/getElement "app")]
    (reagent/render [views/main-panel] app-elem)
    (let [elems (domina/by-class "math")]
      (doall
       (map (fn [elem]
              (k/render (domina/attr elem "data-expr") elem)
              #_(js/renderMathInElement elem))
            elems)))))

(defn ^:export init []
  (re-frame/dispatch-sync [::events/initialize-db])
  (re-frame/dispatch-sync [::rp/add-keyboard-event-listener "keydown"])
  (dev-setup)
  (mount-root))
