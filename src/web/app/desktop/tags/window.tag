<mk-window data-flexible={ isFlexible } data-colored={ opts.colored } ondragover={ ondragover }>
	<div class="bg" ref="bg" show={ isModal } onclick={ bgClick }></div>
	<div class="main" ref="main" tabindex="-1" data-is-modal={ isModal } onmousedown={ onBodyMousedown } onkeydown={ onKeydown }>
		<div class="body">
			<header ref="header" onmousedown={ onHeaderMousedown }>
				<h1 data-yield="header"><yield from="header"/></h1>
				<button class="close" if={ canClose } onmousedown={ repelMove } onclick={ close } title="閉じる"><i class="fa fa-times"></i></button>
			</header>
			<div class="content" data-yield="content"><yield from="content"/></div>
		</div>
		<div class="handle top" if={ canResize } onmousedown={ onTopHandleMousedown }></div>
		<div class="handle right" if={ canResize } onmousedown={ onRightHandleMousedown }></div>
		<div class="handle bottom" if={ canResize } onmousedown={ onBottomHandleMousedown }></div>
		<div class="handle left" if={ canResize } onmousedown={ onLeftHandleMousedown }></div>
		<div class="handle top-left" if={ canResize } onmousedown={ onTopLeftHandleMousedown }></div>
		<div class="handle top-right" if={ canResize } onmousedown={ onTopRightHandleMousedown }></div>
		<div class="handle bottom-right" if={ canResize } onmousedown={ onBottomRightHandleMousedown }></div>
		<div class="handle bottom-left" if={ canResize } onmousedown={ onBottomLeftHandleMousedown }></div>
	</div>
	<style>
		:scope
			display block

			> .bg
				display block
				position fixed
				z-index 2048
				top 0
				left 0
				width 100%
				height 100%
				background rgba(0, 0, 0, 0.7)
				opacity 0
				pointer-events none

			> .main
				display block
				position fixed
				z-index 2048
				top 15%
				left 0
				margin 0
				opacity 0
				pointer-events none

				&:focus
					&:not([data-is-modal])
						> .body
							box-shadow 0 0 0px 1px rgba($theme-color, 0.5), 0 2px 6px 0 rgba(0, 0, 0, 0.2)

				> .handle
					$size = 8px

					position absolute

					&.top
						top -($size)
						left 0
						width 100%
						height $size
						cursor ns-resize

					&.right
						top 0
						right -($size)
						width $size
						height 100%
						cursor ew-resize

					&.bottom
						bottom -($size)
						left 0
						width 100%
						height $size
						cursor ns-resize

					&.left
						top 0
						left -($size)
						width $size
						height 100%
						cursor ew-resize

					&.top-left
						top -($size)
						left -($size)
						width $size * 2
						height $size * 2
						cursor nwse-resize

					&.top-right
						top -($size)
						right -($size)
						width $size * 2
						height $size * 2
						cursor nesw-resize

					&.bottom-right
						bottom -($size)
						right -($size)
						width $size * 2
						height $size * 2
						cursor nwse-resize

					&.bottom-left
						bottom -($size)
						left -($size)
						width $size * 2
						height $size * 2
						cursor nesw-resize

				> .body
					height 100%
					overflow hidden
					background #fff
					border-radius 6px
					box-shadow 0 2px 6px 0 rgba(0, 0, 0, 0.2)

					> header
						z-index 128
						overflow hidden
						cursor move
						background #fff
						border-radius 6px 6px 0 0
						box-shadow 0 1px 0 rgba(#000, 0.1)

						&, *
							user-select none

						> h1
							pointer-events none
							display block
							margin 0
							height 40px
							text-align center
							font-size 1em
							line-height 40px
							font-weight normal
							color #666

						> .close
							cursor pointer
							display block
							position absolute
							top 0
							right 0
							z-index 1
							margin 0
							padding 0
							font-size 1.2em
							color rgba(#000, 0.4)
							border none
							outline none
							background transparent

							&:hover
								color rgba(#000, 0.6)

							&:active
								color darken(#000, 30%)

							> i
								padding 0
								width 40px
								line-height 40px

					> .content
						height 100%

			&:not([flexible])
				> .main > .body > .content
					height calc(100% - 40px)

			&[data-colored]

				> .main > .body

					> header
						box-shadow 0 1px 0 rgba($theme-color, 0.1)

						> h1
							color #d0b4ac

						> .close
							color rgba($theme-color, 0.4)

							&:hover
								color rgba($theme-color, 0.6)

							&:active
								color darken($theme-color, 30%)

	</style>
	<script>
		this.min-height = 40px
		this.min-width = 200px

		this.is-modal = if this.opts.is-modal? then this.opts.is-modal else false
		this.can-close = if this.opts.can-close? then this.opts.can-close else true
		this.is-flexible = !this.opts.height?
		this.can-resize = not @is-flexible

		this.on('mount', () => {
			this.refs.main.style.width = this.opts.width || '530px' 
			this.refs.main.style.height = this.opts.height || 'auto' 

			this.refs.main.style.top = '15%' 
			this.refs.main.style.left = (window.inner-width / 2) - (this.refs.main.offset-width / 2) + 'px' 

			this.refs.header.addEventListener 'contextmenu' (e) =>
				e.preventDefault();

			window.addEventListener 'resize' this.on-browser-resize

			@open!

		this.on('unmount', () => {
			window.removeEventListener 'resize' this.on-browser-resize

		this.on-browser-resize = () => {
			position = this.refs.main.get-bounding-client-rect!
			browser-width = window.inner-width
			browser-height = window.inner-height
			window-width = this.refs.main.offset-width
			window-height = this.refs.main.offset-height

			if position.left < 0
				this.refs.main.style.left = 0

			if position.top < 0
				this.refs.main.style.top = 0

			if position.left + window-width > browser-width
				this.refs.main.style.left = browser-width - window-width + 'px' 

			if position.top + window-height > browser-height
				this.refs.main.style.top = browser-height - window-height + 'px' 

		this.open = () => {
			this.trigger('opening');

			@top!

			if @is-modal
				this.refs.bg.style.pointer-events = 'auto' 
				Velocity(this.refs.bg, 'finish' true
				Velocity(this.refs.bg, {
					opacity: 1
				}, {
					queue: false
					duration: 100ms
					easing: 'linear' 
				}

			this.refs.main.style.pointer-events = 'auto' 
			Velocity(this.refs.main, 'finish' true
			Velocity(this.refs.main, {scale: 1.1} 0ms
			Velocity(this.refs.main, {
				opacity: 1
				scale: 1
			}, {
				queue: false
				duration: 200ms
				easing: 'ease-out' 
			}

			#this.refs.main.focus();

			setTimeout =>
				this.trigger('opened');
			, 300ms

		this.close = () => {
			this.trigger('closing');

			if @is-modal
				this.refs.bg.style.pointer-events = 'none' 
				Velocity(this.refs.bg, 'finish' true
				Velocity(this.refs.bg, {
					opacity: 0
				}, {
					queue: false
					duration: 300ms
					easing: 'linear' 
				}

			this.refs.main.style.pointer-events = 'none' 
			Velocity(this.refs.main, 'finish' true
			Velocity(this.refs.main, {
				opacity: 0
				scale: 0.8
			}, {
				queue: false
				duration: 300ms
				easing: [ 0.5, -0.5, 1, 0.5 ]
			}

			setTimeout =>
				this.trigger('closed');
			, 300ms

		// 最前面へ移動します
		this.top = () => {
			z = 0

			ws = document.query-selector-all 'mk-window' 
			ws.forEach (w) !=>
				if w == this.root then return
				m = w.query-selector ':scope > .main'
				mz = Number(document.default-view.get-computed-style m, null .z-index)
				if mz > z then z := mz

			if z > 0
				this.refs.main.style.z-index = z + 1
				if @is-modal then this.refs.bg.style.z-index = z + 1

		this.repel-move = (e) => {
			e.stopPropagation();
			return true

		this.bg-click = () => {
			if @can-close
				@close!

		this.on-body-mousedown = (e) => {
			@top!
			true

		// ヘッダー掴み時
		this.on-header-mousedown = (e) => {
			e.preventDefault();

			if not contains this.refs.main, document.active-element
				this.refs.main.focus();

			position = this.refs.main.get-bounding-client-rect!

			click-x = e.client-x
			click-y = e.client-y
			move-base-x = click-x - position.left
			move-base-y = click-y - position.top
			browser-width = window.inner-width
			browser-height = window.inner-height
			window-width = this.refs.main.offset-width
			window-height = this.refs.main.offset-height

			// 動かした時
			drag-listen (me) =>
				move-left = me.client-x - move-base-x
				move-top = me.client-y - move-base-y

				// 上はみ出し
				if move-top < 0
					move-top = 0

				// 左はみ出し
				if move-left < 0
					move-left = 0

				// 下はみ出し
				if move-top + window-height > browser-height
					move-top = browser-height - window-height

				// 右はみ出し
				if move-left + window-width > browser-width
					move-left = browser-width - window-width

				this.refs.main.style.left = move-left + 'px' 
				this.refs.main.style.top = move-top + 'px' 

		// 上ハンドル掴み時
		this.on-top-handle-mousedown = (e) => {
			e.preventDefault();

			base = e.client-y
			height = parse-int((get-computed-style this.refs.main, '').height, 10)
			top = parse-int((get-computed-style this.refs.main, '').top, 10)

			// 動かした時
			drag-listen (me) =>
				move = me.client-y - base
				if top + move > 0
					if height + -move > @min-height
						@apply-transform-height height + -move
						@apply-transform-top top + move
					else // 最小の高さより小さくなろうとした時
						@apply-transform-height @min-height
						@apply-transform-top top + (height - @min-height)
				else // 上のはみ出し時
					@apply-transform-height top + height
					@apply-transform-top 0

		// 右ハンドル掴み時
		this.on-right-handle-mousedown = (e) => {
			e.preventDefault();

			base = e.client-x
			width = parse-int((get-computed-style this.refs.main, '').width, 10)
			left = parse-int((get-computed-style this.refs.main, '').left, 10)
			browser-width = window.inner-width

			// 動かした時
			drag-listen (me) =>
				move = me.client-x - base
				if left + width + move < browser-width
					if width + move > @min-width
						@apply-transform-width width + move
					else // 最小の幅より小さくなろうとした時
						@apply-transform-width @min-width
				else // 右のはみ出し時
					@apply-transform-width browser-width - left

		// 下ハンドル掴み時
		this.on-bottom-handle-mousedown = (e) => {
			e.preventDefault();

			base = e.client-y
			height = parse-int((get-computed-style this.refs.main, '').height, 10)
			top = parse-int((get-computed-style this.refs.main, '').top, 10)
			browser-height = window.inner-height

			// 動かした時
			drag-listen (me) =>
				move = me.client-y - base
				if top + height + move < browser-height
					if height + move > @min-height
						@apply-transform-height height + move
					else // 最小の高さより小さくなろうとした時
						@apply-transform-height @min-height
				else // 下のはみ出し時
					@apply-transform-height browser-height - top

		// 左ハンドル掴み時
		this.on-left-handle-mousedown = (e) => {
			e.preventDefault();

			base = e.client-x
			width = parse-int((get-computed-style this.refs.main, '').width, 10)
			left = parse-int((get-computed-style this.refs.main, '').left, 10)

			// 動かした時
			drag-listen (me) =>
				move = me.client-x - base
				if left + move > 0
					if width + -move > @min-width
						@apply-transform-width width + -move
						@apply-transform-left left + move
					else // 最小の幅より小さくなろうとした時
						@apply-transform-width @min-width
						@apply-transform-left left + (width - @min-width)
				else // 左のはみ出し時
					@apply-transform-width left + width
					@apply-transform-left 0

		// 左上ハンドル掴み時
		this.on-top-left-handle-mousedown = (e) => {
			this.on-top-handle-mousedown e
			this.on-left-handle-mousedown e

		// 右上ハンドル掴み時
		this.on-top-right-handle-mousedown = (e) => {
			this.on-top-handle-mousedown e
			this.on-right-handle-mousedown e

		// 右下ハンドル掴み時
		this.on-bottom-right-handle-mousedown = (e) => {
			this.on-bottom-handle-mousedown e
			this.on-right-handle-mousedown e

		// 左下ハンドル掴み時
		this.on-bottom-left-handle-mousedown = (e) => {
			this.on-bottom-handle-mousedown e
			this.on-left-handle-mousedown e

		// 高さを適用
		this.apply-transform-height = (height) => {
			this.refs.main.style.height = height + 'px' 

		// 幅を適用
		this.apply-transform-width = (width) => {
			this.refs.main.style.width = width + 'px' 

		// Y座標を適用
		this.apply-transform-top = (top) => {
			this.refs.main.style.top = top + 'px' 

		// X座標を適用
		this.apply-transform-left = (left) => {
			this.refs.main.style.left = left + 'px' 

		function drag-listen fn
			window.addEventListener 'mousemove'  fn
			window.addEventListener 'mouseleave' drag-clear.bind null fn
			window.addEventListener 'mouseup'    drag-clear.bind null fn

		function drag-clear fn
			window.removeEventListener 'mousemove'  fn
			window.removeEventListener 'mouseleave' drag-clear
			window.removeEventListener 'mouseup'    drag-clear

		this.ondragover = (e) => {
			e.dataTransfer.dropEffect = 'none' 

		this.on-keydown = (e) => {
			if e.which == 27 // Esc
				if @can-close
					e.preventDefault();
					e.stopPropagation();
					@close!

		function contains(parent, child)
			node = child.parentNode
			while node?
				if node == parent
					return true
				node = node.parentNode
			return false
	</script>
</mk-window>
