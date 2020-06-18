HiddenItemScript::
	opentext
	readmem wHiddenItemID
	getitemname STRING_BUFFER_3, USE_SCRIPT_VAR
	writetext .PlayerFoundItemText

        ;; this seems like a good place to start trying to hack on
	;; getting hiddenitems to be interchangeable with pokegear cards.

        ;; there's a call to giveitem right below - could we just
        ;; replace that with giveitem_or_setflag?

        ;; would this break for other hiddenitems that aren't MACHINE_PART?

        ;; from item_constants.asm:
	;; const NO_ITEM      ; $00
	;; const MASTER_BALL  ; $01
	;; const ULTRA_BALL   ; $02
	;; const BRIGHTPOWDER ; $03

        ;; if any of those were a hidden item, then the player would
        ;; get an ENGINE_*_CARD for free.

	giveitem_or_setflag ITEM_FROM_MEM
	iffalse .bag_full
	increment2bytestat sStatsItemsPickedUp
	callasm SetMemEvent
	specialsound
	itemnotify
	sjump .finish

.bag_full
	promptbutton
	writetext .ButNoSpaceText
	waitbutton

.finish
	closetext
	end

.PlayerFoundItemText:
	text_far _PlayerFoundItemText
	text_end

.ButNoSpaceText:
	text_far _ButNoSpaceText
	text_end

SetMemEvent:
	ld hl, wHiddenItemEvent
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld b, SET_FLAG
	call EventFlagAction
	ret
