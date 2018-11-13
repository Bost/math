(ns notes.collapsible
  (:require [reagent.core :as reagent]
            [re-frame.core :as re-frame]
            [katex :as k :refer [render renderMathInElement renderToString]]
            [utils.core :refer [dbgv dbgi]]))

(re-frame/reg-event-db
 :notes/toggle-render-math
 (fn [db [_ _]]
   (update-in db [:render-math] not)))

(re-frame/reg-event-db
  :notes/toggle-panel
  (fn [db [_ id]]
    (update-in db [:open-panels id] not)))

(re-frame/reg-sub
 :notes/render-math-state
 (fn [db [_ _]]
   ;; (.log js/console "db" (pr-str db))
   (get-in db [:render-math])))

(re-frame/reg-sub
  :notes/panel-state
  (fn [db [_ id]]
    ;; (.log js/console "db" (pr-str db))
    (get-in db [:open-panels id])))

(defn component [id content]
  #_(.log js/console "content" content)
  (let [s (reagent/atom 0)]
    (js/setInterval #(swap! s inc) 1000)
    (fn []
      [:div #_@s content])))

(defn e [s] [:span {:class "m" :e s} s])

(defn render-math [render? el]
  ;; see k/renderMathInElement, (k/render exp3 el)
  ;; (.log js/console (.getAttribute el "e"))
  (set! (.-innerHTML el)
        (if render?
          (let [exp0 (.-innerText el)
                exp1 (clojure.string/replace exp0 "◦" "\\circ")
                exp2 (clojure.string/replace exp1 "->" "\\rarr")
                exp3 (clojure.string/replace exp2 "<-" "\\larr")]
            (k/renderToString exp3))
          (.getAttribute el "e"))))

(defn doall-render-math []
  (let [render-math? @(re-frame/subscribe [:notes/render-math-state])]
    (.log js/console "render-math?" render-math?)
    (doall
     (let [elems (.getElementsByClassName js/document "m")]
       (.log js/console "render-math in" (count elems) "elems")
       (map #(render-math render-math? %) elems)))))

(defn panel [id title & children]
  (let [s (reagent/atom {:open false})]
    (fn [id title & children]
      (let [open? @(re-frame/subscribe [:notes/panel-state id])
            child-height (:child-height @s)]
        ;; (.log js/console "open?" open?)
        [:div
         [:div {:on-click (fn [] (re-frame/dispatch [:notes/toggle-panel id]))
                :style {:background-color "#ddd"
                        :padding "0 1em"}}
          [:div {:style {:float "right"}}
           (if open? "-" "+")]
          title]
         [:div {:style  {:overflow "hidden"
                         ;; :transition "max-height 0.8s"
                         :max-height (if open? child-height 0)}}
          [:div {:ref (fn [e]
                        (when e
                          (swap! s assoc :child-height (.-clientHeight e))))
                 :style {:background-color "#eee"
                         :padding "0 1em"}}
           (let [key-id (gensym)]
             (into [:div {:key key-id}] children))]]]))))

(defn ui [{:keys [id title content]}]
  #_(.log js/console "id" id)
  [:div
   [panel id
    title
    #_"Example component"
    [component id content]]])
